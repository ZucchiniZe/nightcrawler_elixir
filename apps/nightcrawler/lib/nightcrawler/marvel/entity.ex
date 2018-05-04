defmodule Nightcrawler.Marvel.Entity do
  @moduledoc """
  All of the API entities should be contain the `api_to_changeset/1` function,
  this is enforcing that
  """

  @doc """
  `transform` is a map that contains functions to run against the schema being
  returned by the api to transform it into schema compatible with our database

  To use transform you need to define a transform function in the entity that
  you want to transform. A transform function is a map that consists of keys
  that target the corresponding string version from the marvel api result.

  ### Example

  For api result json

      %{
        "id" => 1234,
        "title" => "I'm a title"
      }

  The transform function would be

      def transform do
        %{
          id: &Parser.integer_or_string/1,
          title: &Parser.integer_or_string/1
        }
      end
  """
  @callback transform :: %{
              required(atom) =>
                ({String.t(), String.t() | integer | map} ->
                   {atom, String.t() | integer | map})
            }
end
