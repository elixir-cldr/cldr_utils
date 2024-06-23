defmodule CldrUtilsTest do
  use ExUnit.Case, async: true

  doctest Cldr.Utils

  doctest Cldr.Math
  doctest Cldr.Digits
  doctest Cldr.Helpers
  doctest Cldr.Map
  doctest Cldr.String

  if Code.ensure_loaded?(:json) do
    test "Cldr.Json proxy" do
      assert Cldr.Json.decode!("{}") == %{}
    end
  end
end
