defmodule Nightcrawler.MarvelTest do
  @moduledoc false
  use Nightcrawler.DataCase

  alias Nightcrawler.Marvel.Series

  test "test parse_rating" do
    # all the available ratings from the marvel api
    ratings = [
      "RATED T+",
      "ALL AGES",
      "MARVEL PSR",
      "RATED A",
      "Rated T+",
      "PARENTAL ADVISORY",
      "T",
      "T+",
      "All Ages",
      "Parental Advisory",
      "Rated T",
      "Marvel Psr",
      "EXPLICIT CONTENT",
      "A",
      "RATED T",
      "NO RATING",
      "Rated a",
      "PARENTAL ADVISORY/EXPLICIT CONTENT",
      "MARVEL PSR+",
      "NOT IN ORACLE",
      "Mature",
      "PARENTAL ADVISORYSLC",
      "Rated A",
      "Not in Oracle",
      "MAX: EXPLICIT CONTENT",
      "MARVEL AGE (12+)",
      "Parental Advisory/Explicit Content",
      "Explicit Content",
      "Parental Guidance",
      "AGES 12 & UP",
      "Max: Explicit Content",
      "PARENTAL SUPERVISION",
      "17 AND UP",
      "17 & UP",
      "No Rating",
      "13 & Up",
      "PG",
      " ",
      "Parental Advisoryslc"
    ]

    all_ratings =
      ratings
      |> Enum.map(&Series.parse_rating/1)
      |> Enum.uniq()
      |> Enum.sort()

    assert all_ratings == [
             "All Ages",
             "Max: Explicit Content",
             "No Rating",
             "Parental Advisory",
             "T",
             "T+"
           ]
  end
end
