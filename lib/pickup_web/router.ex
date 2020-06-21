defmodule PickupWeb.Router do
  use PickupWeb, :router

  require Ueberauth

  pipeline :auth do
    plug Pickup.Guardian.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: PickupWeb.AuthController
  end

  pipeline :ensure_noauth do
    plug Guardian.Plug.EnsureNotAuthenticated, handler: PickupWeb.AuthController
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PickupWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PickupWeb do
    pipe_through [:browser, :auth, :ensure_noauth]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
  end

  scope "/", PickupWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/logout", SessionController, :logout

    live "/", PageLive, :index
    live "/matches", MatchesLive, :index
    live "/matches/new", NewMatchLive, :index
    live "/matches/:match_name", MatchLive, :index
  end

  scope "/auth", PickupWeb do
    pipe_through :browser

    # get("/login/:provider", AuthController, :login)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PickupWeb do
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
      live_dashboard "/dashboard", metrics: PickupWeb.Telemetry
    end
  end
end
