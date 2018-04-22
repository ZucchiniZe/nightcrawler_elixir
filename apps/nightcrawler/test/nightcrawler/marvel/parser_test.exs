defmodule Nightcrawler.ParserTest do
  use ExUnit.Case, async: true
  doctest Nightcrawler.Parser

  alias Nightcrawler.Parser

  test "that title/1 parses correctly a marvel supplied title strings" do
    assert Parser.title("Captain America: The Man with No Face (2009 - Present)") == %{
             title: "Captain America: The Man with No Face",
             start: 2009,
             end: :present
           }

    assert Parser.title("X-Men: Legacy - Sins of the Father Premiere (2008 - Present)") == %{
             title: "X-Men: Legacy - Sins of the Father Premiere",
             start: 2008,
             end: :present
           }

    assert Parser.title("15 Love (2011)") == %{
             title: "15 Love",
             start: 2011,
             end: nil
           }
  end

  test "that title/1 parses a title with a space" do
    assert Parser.title("Title with space (1111 - 2222)") == %{
             title: "Title with space",
             start: 1111,
             end: 2222
           }
  end

  test "that api_url/1 parses an resource url correctly" do
    assert Parser.api_url("http://gateway.marvel.com/v1/public/comic/31141/characters") == %{
             entity: :comic,
             sub_entity: :characters,
             id: 31_141
           }

    assert Parser.api_url("http://gateway.marvel.com/v1/public/event/79192") == %{
             entity: :event,
             sub_entity: nil,
             id: 79_192
           }
  end
end
