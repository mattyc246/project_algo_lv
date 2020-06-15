defmodule ProjectAlgoLvWeb.Router do
  use ProjectAlgoLvWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ProjectAlgoLvWeb.LayoutView, :app}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ProjectAlgoLvWeb.Auth
  end

  pipeline :authenticated_user do
    plug ProjectAlgoLvWeb.LoginRequired
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  scope "/", ProjectAlgoLvWeb do
    pipe_through :browser

    get "/", HomeController, :index

    get "/invite/:invite_code", UserController, :new
    post "/users/:invite_code", UserController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    post "/logout", SessionController, :delete
  end

  scope "/dashboard", ProjectAlgoLvWeb do
    pipe_through [:browser, :authenticated_user]

    live "/", DashboardLive.Index, :index

    live "/strategies", StrategyLive.Index, :index
    live "/strategies/new", StrategyLive.New, :new
    live "/strategies/:id/edit", StrategyLive.Edit, :edit

    live "/strategies/:id", StrategyLive.Show, :show
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", ProjectAlgoLvWeb do
    pipe_through :api

    post "/strategy/", HistoricalDatumController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ProjectAlgoLvWeb.Telemetry
    end
  end
end
