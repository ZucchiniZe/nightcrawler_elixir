defmodule Nightcrawler.Parser do
  @moduledoc """
  Parses multiple things to deliver neat representations of entities
  """

  @doc """
  Grabs the title and start + end values

  ## Example

      iex> Nightcrawler.Parser.title("Nightcrawler (2011 - 2018)")
      %{title: "Nightcrawler", start: 2011, end: 2018}

      iex> Nightcrawler.Parser.title("Super McBadass Comic Man (1989)")
      %{title: "Super McBadass Comic Man", start: 1989, end: nil}

      iex> Nightcrawler.Parser.title("Some Title (2018 - Present)")
      %{title: "Some Title", start: 2018, end: :present}

  """
  def title(title) do
    # i hate regex.
    regex = ~R/^(?<title>.+)
                \s\(
                  (?<start>\d{4})
                  (?:
                    (?:\s|-)+
                    (?<end>\d{4}|Present)
                  )?
                \)$/x

    Regex.named_captures(regex, title)
    |> Enum.map(fn {k, v} ->
      key = String.to_atom(k)

      cond do
        v == "" ->
          {key, nil}

        key == :start ->
          {key, String.to_integer(v)}

        key == :end and v == "Present" ->
          {key, v |> String.downcase() |> String.to_atom()}

        key == :end ->
          {key, String.to_integer(v)}

        true ->
          {key, v}
      end
    end)
    |> Enum.into(%{})
  end

  @doc """
  Parses the entity urls that are returned by the marvel api

  ## Examples

      iex> Nightcrawler.Parser.api_url("http://gateway.marvel.com/v1/public/series/18454/characters")
      %{entity: :series, id: 18454, sub_entity: :characters}

      iex> Nightcrawler.Parser.api_url("http://gateway.marvel.com/v1/public/series/18454")
      %{entity: :series, id: 18454, sub_entity: nil}

  """
  def api_url(url) do
    regex = ~R"^http://gateway.marvel.com/v1/public/
                (?<entity>\w+)/(?<id>\d+)(?:/(?<sub_entity>\w+))?$"x

    Regex.named_captures(regex, url)
    |> Enum.map(fn {k, v} ->
      key = String.to_atom(k)

      cond do
        key == :id ->
          {key, String.to_integer(v)}

        key == :sub_entity and v == "" ->
          {key, nil}

        key == :entity or key == :sub_entity ->
          {key, String.to_atom(v)}

        true ->
          {k, v}
      end
    end)
    |> Enum.into(%{})
  end
end
