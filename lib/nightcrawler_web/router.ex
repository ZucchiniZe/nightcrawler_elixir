defmodule NightcrawlerWeb.Router do
  use NightcrawlerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NightcrawlerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/comics", PageController, :comics
    get "/comics/:comic_id", PageController, :comics
  end

  # Other scopes may use custom stacks.
  # scope "/api", NightcrawlerWeb do
  #   pipe_through :api
  # end
end
