defmodule ArtTest do
  use ExUnit.Case
  doctest Art

  test "greets the world" do
    assert Art.hello() == :world
  end
end
