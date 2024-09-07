defmodule ChronusTest do
  use ExUnit.Case
  doctest Chronus

  test "greets the world" do
    assert Chronus.hello() == :world
  end
end
