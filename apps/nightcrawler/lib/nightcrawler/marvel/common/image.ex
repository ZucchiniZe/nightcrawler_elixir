defmodule Nightcrawler.Marvel.Common.Image do
  @moduledoc """
  Every entity has a `thumbnail` dataum so we make one easily storable
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :path, :string
    field :extension, :string
  end

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:path, :extension])
    |> http_to_https
  end

  def http_to_https(changeset) do
    https_url =
      get_change(changeset, :path)
      |> URI.parse()
      |> Map.put(:scheme, "https")
      |> Map.put(:port, nil)
      |> URI.to_string()

    put_change(changeset, :path, https_url)
  end

  @doc """
  # Generates a correct URL given an Image struct

  ## Variant list

  ### Portrait aspect ratio

  - `:portrait_small`: 50x75px
  - `:portrait_medium`: 100x150px
  - `:portrait_xlarge`: 150x225px
  - `:portrait_fantastic`: 168x252px
  - `:portrait_incredible`: 216x324px
  - `:portrait_uncanny`: 300x450px

  ### Standard (square) aspect ratio

  - `:standard_small`: 65x45px
  - `:standard_medium`: 100x100px
  - `:standard_large`: 140x140px
  - `:standard_xlarge`: 200x200px
  - `:standard_amazing`: 180x180px
  - `:standard_fantastic`: 250x250px

  ### Landscape aspect ratio

  - `:landscape_small`: 120x90px
  - `:landscape_medium`: 175x130px
  - `:landscape_large`: 190x140px
  - `:landscape_amazing`: 250x156px
  - `:landscape_xlarge`: 270x200px
  - `:landscape_incredible`: 464x261px

  ### Full Size images

  constrained to 500px wide
  without any variant descriptior
  """
  def thumbnail_url(image, variant), do: "#{image.path}/#{to_string(variant)}.#{image.extension}"
  def thumbnail_url(image), do: "#{image.path}.#{image.extension}"
end
