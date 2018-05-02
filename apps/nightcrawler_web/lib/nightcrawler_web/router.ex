defmodule NightcrawlerWeb.Router do
  use NightcrawlerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlugServerTiming.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NightcrawlerWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/", PageController, :index
    get "/stats", PageController, :cache_stats

    get "/series", SeriesController, :index
    get "/series/:id", SeriesController, :get

    get "/events", EventsController, :index

    get "/characters", CharacterController, :index
  end
end
