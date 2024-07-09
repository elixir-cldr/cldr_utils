defmodule CldrUtilsTest do
  use ExUnit.Case, async: true

  doctest Cldr.Utils

  doctest Cldr.Math
  doctest Cldr.Digits
  doctest Cldr.Helpers
  doctest Cldr.Map
  doctest Cldr.String

  if Code.ensure_loaded?(Cldr.Json) do
    test "Cldr.Json proxy" do
      assert %{} = Cldr.Json.decode!("{}")
      assert %{"foo" => 1} = Cldr.Json.decode!("{\"foo\": 1}")
      assert %{foo: 1} = Cldr.Json.decode!("{\"foo\": 1}", keys: :atoms)
    end
  end
end
