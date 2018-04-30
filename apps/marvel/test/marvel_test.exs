defmodule MarvelTest do
  @moduledoc false
  use ExUnit.Case, async: true
  @moduletag :external
  doctest Marvel

  test "cache caches the value on the second try" do
    assert {:ok, false} = Cachex.exists?(:marvel_cache, "https://httpbin.org/?")
    Marvel.get("https://httpbin.org/")
    assert {:ok, true} = Cachex.exists?(:marvel_cache, "https://httpbin.org/?")
  end
end
