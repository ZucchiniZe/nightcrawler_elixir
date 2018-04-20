defmodule MarvelTest do
  use ExUnit.Case
  doctest Marvel

  test "greets the world" do
    assert Marvel.hello() == :world
  end
end
