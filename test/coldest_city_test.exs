defmodule ColdestCityTest do
  use ExUnit.Case
  doctest ColdestCity

  test "greets the world" do
    assert ColdestCity.hello() == :world
  end
end
