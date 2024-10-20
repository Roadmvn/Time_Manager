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

  scope "/", TimeManagerWeb do
    pipe_through :browser

    get "/", PageController, :home
  end




  # Other scopes may use custom stacks.
  # scope "/api", TimeManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/logout", AuthController, :logout

    resources "/users", UserController, except: [:new, :edit]
    resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
    resources "/clocks", ClockController, except: [:new, :edit]
    resources "/teams", TeamController, except: [:new, :edit]

    post "/teams/:id/working_time", TeamController, :create_working_time

    put "/users/:id/promote_manager", UserController, :promote_to_manager
    put "/users/:id/promote_admin", UserController, :promote_to_admin
    put "/users/:id/demote", UserController, :demote_to_user
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/tutorials", TutorialController, except: [:new, :edit]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/flexible_working_times", FlexibleWorkingTimeController, except: [:new, :edit]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/reminders", ReminderController, except: [:new, :edit]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/night_shifts", NightShiftController, except: [:new, :edit]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/roles", RoleController, except: [:new, :edit]
    resources "/permissions", PermissionController, except: [:new, :edit]
    post "/roles/:role_id/permissions/:permission_id", RoleController, :add_permission
    delete "/roles/:role_id/permissions/:permission_id", RoleController, :remove_permission
  end


end
