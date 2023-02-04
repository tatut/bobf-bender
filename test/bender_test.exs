defmodule BenderTest do
  use ExUnit.Case
  doctest Bender

  test "greets the world" do
    assert Bender.hello() == :world
  end
end
