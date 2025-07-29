defmodule HomeWeb.Router do
  use HomeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HomeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HomeWeb.Redirects
  end

  scope "/", HomeWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/cv", PageController, :cv
    get "/writing", ArticleController, :index
    get "/writing/:id", ArticleController, :show
    get "/rss", RSSController, :index

    live_session :default do
      scope "/tools" do
        live "/wheel-of-life", WheelOfLifeLive
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomeWeb do
  #   pipe_through :api
  # end

  if Application.compile_env(:home, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HomeWeb.Telemetry
    end
  end
end
