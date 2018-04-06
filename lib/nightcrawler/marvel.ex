defmodule Nightcrawler.Marvel do
  @moduledoc """
  Marvel API Wrapper
  Uses Tesla to make requests with special middleware to satisfy marvel auth
  and uses Cachex to cache the calls for greater response times.
  """
  use Tesla
  @version Mix.Project.config[:version]

  # plug Tesla.Middleware.Logger
  plug Tesla.Middleware.BaseUrl, "https://gateway.marvel.com/v1/public"
  plug Tesla.Middleware.Headers, [{"User-Agent", "nightcrawler/#{@version}"}]
  plug Nightcrawler.Marvel.Middleware.Auth
  plug Tesla.Middleware.DecodeJson

  ### CHARACTERS

  def get_characters(id, query \\ []) do
    if id == nil do
      Cachex.fetch(:characters, "all_#{query}", fn ->
        case get("/characters", query: query) do
          {:ok, response} -> response.body
          {:error, _reason} = error -> {:ignore, error}
        end
      end)
    else
      Cachex.fetch(:characters, "#{id}_#{query}", fn ->
        case get("/characters/#{id}", query: query) do
          {:ok, response} -> response.body
          {:error, _reason} = error -> {:ignore, error}
        end
      end)
    end
  end

  def get_characters_comics(id, query \\ []) do
    Cachex.fetch(:characters, "#{id}_comics_#{query}", fn ->
      case get("/characters/#{id}/comics", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  def get_characters_events(id, query \\ []) do
    Cachex.fetch(:characters, "#{id}_events_#{query}", fn ->
      case get("/characters/#{id}/events", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  def get_characters_creators(id, query \\ []) do
    Cachex.fetch(:characters, "#{id}_creators_#{query}", fn ->
      case get("/characters/#{id}/creators", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  def get_characters_stories(id, query \\ []) do
    Cachex.fetch(:characters, "#{id}_stories_#{query}", fn ->
      case get("/characters/#{id}/stories", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  ### COMICS

  @doc """
  Gets all the data about a comic based on it's ID
  OR if id == nil, then return list of all comics
  """
  def get_comics(id, query \\ []) do
    if id == nil do
      Cachex.fetch(:comics, "all_#{query}", fn ->
        case get("/comics", query: query) do
          {:ok, response} -> response.body
          {:error, _reason} = error -> {:ignore, error}
        end
      end)
    else
      Cachex.fetch(:comics, "#{id}_#{query}", fn ->
        case get("/comics/#{id}", query: query) do
          {:ok, response} -> response.body
          {:error, _reason} = error -> {:ignore, error}
        end
      end)
    end
  end

  def get_comics_characters(id, query \\ []) do
    Cachex.fetch(:comics, "#{id}_characters_#{query}", fn ->
      case get("/comics/#{id}/characters", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  def get_comics_creators(id, query \\ []) do
    Cachex.fetch(:comics, "#{id}_creators_#{query}", fn ->
      case get("/comics/#{id}/creators", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  def get_comics_events(id, query \\ []) do
    Cachex.fetch(:comics, "#{id}_events_#{query}", fn ->
      case get("/comics/#{id}/events", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end

  def get_comics_stories(id, query \\ []) do
    Cachex.fetch(:comics, "#{id}_stories_#{query}", fn ->
      case get("/comics/#{id}/stories", query: query) do
        {:ok, response} -> {:commit, response.body}
        {:error, _reason} = error -> {:ignore, error}
      end
    end)
  end
end
