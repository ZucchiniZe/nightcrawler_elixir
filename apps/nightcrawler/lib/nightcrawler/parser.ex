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

    regex
    |> Regex.named_captures(title)
    |> Enum.map(fn {k, v} ->
      key = String.to_atom(k)

      cond do
        v == "" ->
          {key, nil}

        key == :end and v == "Present" ->
          {key, v |> String.downcase() |> String.to_atom()}

        key in ~w(start end)a ->
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

    regex
    |> Regex.named_captures(url)
    |> Enum.map(fn {k, v} ->
      key = String.to_atom(k)

      cond do
        key == :id ->
          {key, String.to_integer(v)}

        key == :sub_entity and v == "" ->
          {key, nil}

        key in ~w(entity sub_entity)a ->
          {key, String.to_atom(v)}

        true ->
          {k, v}
      end
    end)
    |> Enum.into(%{})
  end

  @doc """
  Takes a raw `api_result` and an entity definition and transforms into a
  compatible map of values using the functions defined in the `transform_definition`
  """
  def transform_entity(api_result, transform_definition) do
    api_result
    |> Enum.map(fn {key, _val} = row ->
      key_atom = String.to_atom(key)

      case Map.fetch(transform_definition, key_atom) do
        {:ok, func} ->
          func.(row)

        :error ->
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end

  # parser functions

  @doc """
  Converts a key value pair with a camelCased key to a snake_cased key
  """
  @spec underscore_key({String.t, String.t | integer}) :: {String.t, String.t | integer}
  def underscore_key({key, val}),
    do: {key |> Macro.underscore() |> String.to_existing_atom(), val}

  @doc """
  Passes through the key value pair while converting the key to an atom
  """
  @spec integer_or_string({String.t, String.t | integer}) :: {String.t, String.t | integer}
  def integer_or_string({key, val}), do: {String.to_existing_atom(key), val}

  @doc """
  Converts the key value pair with a datetime string to a compatible datetime
  or nil if not compatible
  """
  @spec maybe_datetime({String.t, String.t}) :: nil | {String.t, String.t}
  def maybe_datetime({key, val}) do
    case DateTime.from_iso8601(val) do
      {:ok, datetime, _offset} ->
        {String.to_existing_atom(key), datetime}

      {:error, _reason} ->
        nil
    end
  end

  @doc """
  Converts the thumbnail key value pair to a compatible key value pair
  """
  @spec thumbnail({String.t, map}) :: {String.t, map}
  def thumbnail({key, val}) do
    {String.to_existing_atom(key), %{extension: val["extension"], path: val["path"]}}
  end
end
