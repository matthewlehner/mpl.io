%{
title: "Instrumenting Phoenix with Prometheus",
date: "2024-03-17T00:00Z",
path: "instrumenting-phoenix-with-prometheus",
description: "Phoenix provides Telemetry.Metrics out of the box, but they aren't persisted anywhere. I wanted to get them into Prometheus so the metrics we report can be viewed and used in Grafana."
}
---

I recently rebuilt this site with Phoenix and hosted it on Fly.io. Full
disclosure, I'm working at Fly.io right now, and have been curious about some of
the different products we offer that don't seem to be used that much. Today, it
was getting telemetry metrics out of Phoenix so it's visible in Grafana.

## Why export `Telemetry.Metrics` to Prometheus?

Out of the box, Phoenix adds some basic telemetry metrics that LiveDashboard
displays in the performance tab. While LiveDashboard is useful while you're
looking at it, the metrics it displays are not persisted so we can't view them
over time or use them for alerting.

I had originally looked into OpenTelemetry because I like the idea of open
standards. However, for what I want to do (get metrics into Grafana), it wasn't
the right fit. I don't need the tracing aspects and getting open telemetry data
into a format that Prometheus could deal with was not straightforward.

First, I tried
[`telemetry_metrics_prometheus`](https://github.com/beam-telemetry/telemetry_metrics_prometheus),
but it raised exceptions when trying to use distribution metrics.

I settled on [Peep](https://github.com/rkallos/peep), which is listed in the
Reporters section of the
[`Telemetry.Metrics` readme](https://github.com/beam-telemetry/telemetry_metrics?tab=readme-ov-file#reporters).
This library worked and does what I need it to – take metrics and turn them
into something Prometheus can scrape.

## What Are We Gonna Do?

To make this work, we need to get metrics into Fly.io's Prometheus instance,
then those will be available in the managed Grafana instance.

Here's what that looks like:

1. Turn Phoenix's metrics into a format that Prometheus can scrape
2. Expose an endpoint that these metrics can be scraped from
3. Do stuff with the metrics in Grafana

Everything past this point assumes you've got a Phoenix app with a
`MyAppWeb.Telemetry` module and the `telemetry_metrics` dependency installed
already.

## Preparing telemetry for Prometheus consumption

For this, I chose Peep as it seems to be the most maintained option (and it
supports the `distribution`
[metric type in `Telemetry.Metrics`](https://hexdocs.pm/telemetry_metrics/Telemetry.Metrics.html#module-metrics)).

Add it to your dependencies
([example commit](https://github.com/matthewlehner/mpl.io/commit/1227747500132c598bb9cf0cc9ef1b8105c0819a))
and install it with `mix deps.get`. Now we need to change the default metric
types from `summary`, which isn't supported by Peep, to `last_value` or
`duration`. Open up `telemetry.ex` and make these changes. Here's a couple, for
example:

```elixir
def metrics do
  [
    # Phoenix Metrics
    distribution("phoenix.endpoint.start.system_time",
      unit: {:native, :millisecond}
    ),
    distribution("phoenix.endpoint.stop.duration",
      unit: {:native, :millisecond}
    ),
    # others omitted for brevity

    # VM Metrics
    last_value("vm.memory.total", unit: {:byte, :kilobyte}),
    last_value("vm.total_run_queue_lengths.total"),
    last_value("vm.total_run_queue_lengths.cpu"),
    last_value("vm.total_run_queue_lengths.io")
  ]
end
```

Next, we need to add Peep to our telemetry supervision tree. Add the following
line to the list of `children`, but change the name to match your app's name.

```elixir
{Peep, name: MyAppPeep, metrics: metrics()}
```

It should look something like this:

```elixir
def MyAppWeb.Telemetry do
  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      {Peep, name: MyAppPeep, metrics: metrics()},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

Once that's done, you can run `iex -S mix` and you can test this out by running
the following command:

```elixir
iex(1)> MyAppPeep |> Peep.get_all_metrics() |> Peep.Prometheus.export()
```

If that's working, you're ready to expose at an endpoint that Prometheus can
scrape.

## Exposing `/metrics`

We don't want to make the metrics endpoint available publicly. I mean, you
could… but I don't want to, so I did some extra work to make sure no one can get
it, except Prometheus.

First, write the plug that will serve these responses. I put it in
`lib/my_app_web/telemetry/peep_plug.ex` and it looks like this:

```elixir
defmodule MyAppWeb.Telemetry.PeepPlug do
  use Plug.Router
  alias Plug.Conn

  plug :match
  plug Plug.Telemetry, event_prefix: [MyAppPeep, :plug]
  plug :dispatch

  get "/metrics" do
    name = MyAppPeep
    metrics = name |> Peep.get_all_metrics() |> Peep.Prometheus.export()

    conn
    |> Conn.put_private(:prometheus_metrics_name, name)
    |> Conn.put_resp_content_type("text/plain")
    |> Conn.send_resp(200, metrics)
  end

  match _ do
    Conn.send_resp(conn, 404, "Not Found")
  end
end
```

If you're curious about what's going on here,
[the docs for Plug.Router](https://hexdocs.pm/plug/1.15.3/Plug.Router.html) are
a good read.

Next, we need a Bandit server. Head back to your telemetry supervisor in the
`MyAppWeb.Telemetry` module and we'll add that to the supervision tree:

```elixir
 def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      {Peep, name: MyAppPeep, metrics: metrics()},
      {Bandit, plug: MyAppWeb.Telemetry.PeepPlug, port: 9091}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
```

Now, when you start your server with `mix phx.sever`, you should see two
different bandit endpoints starting.

If everything worked, visit http://localhost:9091/metrics and you'll see some
stuff that Prometheus can scrape. Hurah!

The last step is to tell Fly.io about these changes by updating your `fly.toml`
like this:

```toml
[[metrics]]
  port = 9091
  path = "/metrics"
```

Now `fly deploy` these changes.

## Doing stuff with Grafana

Now we've got some stuff going on, you can open your metrics dashboard
`fly dashboard metrics` and then click on the "Open all on Grafana" button:

<img alt="Open Grafana link screenshot" src="/images/articles/instrumenting-phoenix-with-prometheus/grafana-link-screenshot.webp" width="212" />

Head over to the explore tab in Grafana and search for one of the metrics you're
now exporting. Here's what my `vm_memory_total` now looks like:

<img alt="A Grafana dashboard" src="/images/articles/instrumenting-phoenix-with-prometheus/grafana-dashboard-screenshot.webp" width="738" />

That's it!

For all the code, have a look at
[the commits on Github](https://github.com/matthewlehner/mpl.io/compare/01d7c76e10e22c59f3f3ea026851fe6d52175eaa...ad3864d23b7e0d80cde8054d746598966d5dfb75).

I think the next thing I'm going to try is setting up some site analytics around
pageviews with telemetry in Elixir.
