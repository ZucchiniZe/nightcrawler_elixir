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

  test "doesn't timeout at 5 secods" do
    assert _ = Marvel.get("https://httpbin.org/delay/5")
  end

  test "doesn't timeout at 7 seconds" do
    assert _ = Marvel.get("https://httpbin.org/delay/7")
  end

  test "doesn't timeout at 9 seconds" do
    assert _ = Marvel.get("https://httpbin.org/delay/9")
  end

  test "times out at 10 seconds" do
    assert {:error, :timeout} = Marvel.get("https://httpbin.org/delay/10")
  end

  test "times out at 13 seconds" do
    assert {:error, :timeout} = Marvel.get("https://httpbin.org/delay/13")
  end
end
