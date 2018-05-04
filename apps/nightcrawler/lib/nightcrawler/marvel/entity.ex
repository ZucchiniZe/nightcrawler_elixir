defmodule Nightcrawler.Marvel.Entity do
  @moduledoc """
  All of the API entities should be contain the `api_to_changeset/1` function, this is enforcing that
  """

  @doc """
  `transform` is a map that contains functions to run against the schema being
  returned by the api to transform it into schema compatible with our database
  """
  @callback transform :: %{
              required(atom) =>
                ({String.t(), String.t() | integer | map} ->
                   {atom, String.t() | integer | map})
            }
end
