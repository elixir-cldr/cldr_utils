defmodule CldrUtilsTest do
  use ExUnit.Case, async: true

  doctest Cldr.Utils

  doctest Cldr.Math
  doctest Cldr.Digits
  doctest Cldr.Helpers
  doctest Cldr.Map
  doctest Cldr.String
end
