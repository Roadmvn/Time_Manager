defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TimeManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate_user do
    plug TimeManagerWeb.AuthPlug
  end

  scope "/", TimeManagerWeb do
    pipe_through :browser
    get "/", PageController, :home
  end

  if Application.compile_env(:time_manager, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # Regroupement des routes API
  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Routes publiques
    post "/signup", UserController, :create
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout

    # Routes nécessitant une authentification
    pipe_through :authenticate_user

    # Route pour récupérer les informations de l'utilisateur connecté
    get "/users/me", UserController, :get_me

    # Gestion des utilisateurs
    resources "/users", UserController, except: [:new, :edit]
    put "/users/:id/promote_manager", UserController, :promote_to_manager
    put "/users/:id/promote_admin", UserController, :promote_to_admin
    put "/users/:id/demote", UserController, :demote_to_user

    # Gestion des teams et des working times
    resources "/teams", TeamController, except: [:new, :edit]
    post "/teams/:id/working_time", TeamController, :create_working_time

    # Gestion des autres ressources
    resources "/clocks", ClockController, except: [:new, :edit]
    resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
    resources "/flexible_working_times", FlexibleWorkingTimeController, except: [:new, :edit]
    resources "/reminders", ReminderController, except: [:new, :edit]
    resources "/night_shifts", NightShiftController, except: [:new, :edit]
    resources "/roles", RoleController, except: [:new, :edit]
    resources "/permissions", PermissionController, except: [:new, :edit]
    post "/roles/:role_id/permissions/:permission_id", RoleController, :add_permission
    delete "/roles/:role_id/permissions/:permission_id", RoleController, :remove_permission
  end
end
