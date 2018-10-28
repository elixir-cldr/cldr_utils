defmodule CldrUtilsTest do
  use ExUnit.Case
  doctest CldrUtils

  test "greets the world" do
    assert CldrUtils.hello() == :world
  end
end
