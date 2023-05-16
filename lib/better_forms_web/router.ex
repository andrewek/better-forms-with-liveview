defmodule BetterFormsWeb.Router do
  use BetterFormsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BetterFormsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BetterFormsWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/invoices", InvoiceLive.Index, :index

    live "/invoices/new-1", InvoiceLive.New1, :new
    live "/invoices/new-2", InvoiceLive.New2, :new
    live "/invoices/new-3", InvoiceLive.New3, :new

    live "/invoices/:id", InvoiceLive.Show, :show
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:better_forms, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BetterFormsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
