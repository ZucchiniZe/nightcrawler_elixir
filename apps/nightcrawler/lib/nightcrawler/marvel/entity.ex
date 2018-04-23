defmodule Nightcrawler.Marvel.Entity do
  @moduledoc """
  All of the API entities should be contain the `api_to_changeset/1` function, this is enforcing that
  """

  @callback api_to_changeset(map) :: map
end
