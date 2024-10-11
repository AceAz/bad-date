defmodule BadDateWeb.Router do
  use BadDateWeb, :router

  import BadDateWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BadDateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BadDateWeb do
    pipe_through :browser

    get "/matches", MatchesController, :show

    get "/profile/new", ProfileController, :new
    get "/profile/:id/edit", ProfileController, :edit
    put "/profile/:id", ProfileController, :update
    get "/profile/:id", ProfileController, :show

    post "/profile", ProfileController, :create
    get "/profile", ProfileController, :index
    #Messaging routes
    resources "/messages", MessagingController, only: [:new, :create, :index]
   
    #Blocking routes
    post "/block", BlockController, :block  # Route to block a user
    delete "/block/:blocked_id", BlockController, :unblock  # Route to unblock a user
    get "/blocked", BlockController, :index
   
    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", BadDateWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bad_date, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BadDateWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BadDateWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", BadDateWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", BadDateWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  scope "/", BadDateWeb do
    pipe_through [:browser]

    patch "/users/pause_account", UserSettingsController, :pause_account
    patch "/users/unpause_account", UserSettingsController, :unpause_account
  end
end
