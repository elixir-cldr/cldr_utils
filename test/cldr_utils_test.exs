defmodule CldrUtilsTest do
  use ExUnit.Case
  doctest CldrUtils

  doctest Cldr.Math
  doctest Cldr.Digits
  doctest Cldr.Helpers
  doctest Cldr.Map
  doctest Cldr.String

  test "greets the world" do
    assert CldrUtils.hello() == :world
  end
end
