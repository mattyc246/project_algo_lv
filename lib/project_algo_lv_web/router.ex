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
    # live "/", HomeLive, :index
    # live "/users", UserLive.Index, :index
    # live "/invite/:invite_code", UserLive.New, :new
    # live "/users/:id/edit", UserLive.Index, :edit

    # live "/users/login", UserLive.Session, :new

    # live "/users/:id", UserLive.Show, :show
    # live "/users/:id/show/edit", UserLive.Show, :edit
  end

  scope "/", ProjectAlgoLvWeb do
    pipe_through [:browser, :authenticated_user]

    live "/dashboard", DashboardLive.Index, :index
    live "/dashboard/accounts", AccountsLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProjectAlgoLvWeb do
  #   pipe_through :api
  # end

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
