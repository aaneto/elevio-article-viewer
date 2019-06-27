defmodule ElevioTest do
  use ExUnit.Case
  doctest Elevio

  test "greets the world" do
    assert Elevio.hello() == :world
  end
end
