defmodule HomeWeb.PageHTML do
  use HomeWeb, :html

  embed_templates "page_html/*"

  attr :icon, :atom, required: true, values: [:github, :linkedin]
  attr :rest, :global, include: ~w(href)

  def social_link(assigns) do
    ~H"""
    <.link class="group -m-1 p-1" {@rest}>
      <.social_icon
        icon={@icon}
        class="h-6 w-6 fill-zinc-500 transition group-hover:fill-zinc-600 dark:fill-zinc-400 dark:group-hover:fill-zinc-300"
      />
    </.link>
    """
  end

  attr :icon, :atom, required: true, values: [:github, :linkedin]
  attr :rest, :global

  def social_icon(%{icon: :github} = assigns) do
    ~H"""
    <svg viewBox="0 0 24 24" aria-hidden="true" {@rest}>
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M12 2C6.475 2 2 6.588 2 12.253c0 4.537 2.862 8.369 6.838 9.727.5.09.687-.218.687-.487 0-.243-.013-1.05-.013-1.91C7 20.059 6.35 18.957 6.15 18.38c-.113-.295-.6-1.205-1.025-1.448-.35-.192-.85-.667-.013-.68.788-.012 1.35.744 1.538 1.051.9 1.551 2.338 1.116 2.912.846.088-.666.35-1.115.638-1.371-2.225-.256-4.55-1.14-4.55-5.062 0-1.115.387-2.038 1.025-2.756-.1-.256-.45-1.307.1-2.717 0 0 .837-.269 2.75 1.051.8-.23 1.65-.346 2.5-.346.85 0 1.7.115 2.5.346 1.912-1.333 2.75-1.05 2.75-1.05.55 1.409.2 2.46.1 2.716.637.718 1.025 1.628 1.025 2.756 0 3.934-2.337 4.806-4.562 5.062.362.32.675.936.675 1.897 0 1.371-.013 2.473-.013 2.82 0 .268.188.589.688.486a10.039 10.039 0 0 0 4.932-3.74A10.447 10.447 0 0 0 22 12.253C22 6.588 17.525 2 12 2Z"
      />
    </svg>
    """
  end

  def social_icon(%{icon: :linkedin} = assigns) do
    ~H"""
    <svg viewBox="0 0 24 24" aria-hidden="true" {@rest}>
      <path d="M18.335 18.339H15.67v-4.177c0-.996-.02-2.278-1.39-2.278-1.389 0-1.601 1.084-1.601 2.205v4.25h-2.666V9.75h2.56v1.17h.035c.358-.674 1.228-1.387 2.528-1.387 2.7 0 3.2 1.778 3.2 4.091v4.715zM7.003 8.575a1.546 1.546 0 01-1.548-1.549 1.548 1.548 0 111.547 1.549zm1.336 9.764H5.666V9.75H8.34v8.589zM19.67 3H4.329C3.593 3 3 3.58 3 4.297v15.406C3 20.42 3.594 21 4.328 21h15.338C20.4 21 21 20.42 21 19.703V4.297C21 3.58 20.4 3 19.666 3h.003z" />
    </svg>
    """
  end

  def work_experience(assigns) do
    ~H"""
    <div class="rounded-2xl border border-zinc-100 p-6 dark:border-zinc-700/40">
      <h2 class="flex text-sm font-semibold text-zinc-900 dark:text-zinc-100">
        <svg
          viewBox="0 0 24 24"
          fill="none"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round"
          aria-hidden="true"
          class="h-6 w-6 flex-none"
        >
          <path
            d="M2.75 9.75a3 3 0 0 1 3-3h12.5a3 3 0 0 1 3 3v8.5a3 3 0 0 1-3 3H5.75a3 3 0 0 1-3-3v-8.5Z"
            class="fill-zinc-100 stroke-zinc-400 dark:fill-zinc-100/10 dark:stroke-zinc-500"
          >
          </path>
          <path
            d="M3 14.25h6.249c.484 0 .952-.002 1.316.319l.777.682a.996.996 0 0 0 1.316 0l.777-.682c.364-.32.832-.319 1.316-.319H21M8.75 6.5V4.75a2 2 0 0 1 2-2h2.5a2 2 0 0 1 2 2V6.5"
            class="stroke-zinc-400 dark:stroke-zinc-500"
          >
          </path>
        </svg>
        <span class="ml-3">Work</span>
      </h2>
      <ol class="mt-6 space-y-4">
        <li :for={role <- @roles} class="flex gap-4">
          <div class="relative mt-1 flex h-10 w-10 flex-none items-center justify-center rounded-full shadow-md shadow-zinc-800/5 ring-1 ring-zinc-900/5 dark:border dark:border-zinc-700/50 dark:bg-zinc-800 dark:ring-0">
            <img src={role.logo} alt={"#{role.company} logo"} class="h-7 w-7" />
          </div>
          <dl class="flex flex-auto flex-wrap gap-x-2">
            <dt class="sr-only">Company</dt>
            <dd class="w-full flex-none text-sm font-medium text-zinc-900 dark:text-zinc-100">
              {role.company}
            </dd>
            <dt class="sr-only">Role</dt>
            <dd class="text-xs text-zinc-500 dark:text-zinc-400">
              {role.title}
            </dd>
            <dt class="sr-only">Date</dt>
            <dd
              class="ml-auto text-xs text-zinc-400 dark:text-zinc-500"
              aria-label={"#{if is_map(role.start), do: role.start.label, else: role.start} until #{if is_map(role.end), do: role.end.label, else: role.end}"}
            >
              <time datetime={if is_map(role.start), do: role.start.dateTime, else: role.start}>
                {if is_map(role.start), do: role.start.label, else: role.start}
              </time>
              <span aria-hidden="true">—</span>
              <time datetime={if is_map(role.end), do: role.end.dateTime, else: role.end}>
                {if is_map(role.end), do: role.end.label, else: role.end}
              </time>
            </dd>
          </dl>
        </li>
      </ol>
      <.link
        class="inline-flex items-center gap-2 justify-center rounded-md py-2 px-3 text-sm outline-offset-2 transition active:transition-none bg-zinc-50 font-medium text-zinc-900 hover:bg-zinc-100 active:bg-zinc-100 active:text-zinc-900/60 dark:bg-zinc-800/50 dark:text-zinc-300 dark:hover:bg-zinc-800 dark:hover:text-zinc-50 dark:active:bg-zinc-800/50 dark:active:text-zinc-50/70 group mt-6 w-full"
        href={~p"/resources/MatthewLehnerCV.pdf"}
      >
        Download CV
        <.icon
          name="hero-arrow-down"
          class="h-4 w-4 stroke-zinc-400 transition group-active:stroke-zinc-600 dark:group-hover:stroke-zinc-50 dark:group-active:stroke-zinc-50"
        />
      </.link>
    </div>
    """
  end
end
