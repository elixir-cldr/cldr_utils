defmodule Support.Map.Test do
  use ExUnit.Case

  test "that map keys are underscored" do
    assert Cldr.Map.underscore_keys(%{"thisKey" => "value"}) == %{"this_key" => "value"}
  end

  test "that map keys are atomised" do
    assert Cldr.Map.atomize_keys(%{"thisKey" => "value"}) == %{thisKey: "value"}
  end

  test "that nested map keys are atomised" do
    test_map = %{
      "key" => %{
        "nested" => "value"
      }
    }

    test_result = %{
      key: %{
        nested: "value"
      }
    }

    assert Cldr.Map.atomize_keys(test_map) == test_result
  end

  test "that interizing negative integer keys works" do
    map = %{"-1" => "something"}
    result = %{-1 => "something"}

    assert Cldr.Map.integerize_keys(map) == result
  end

  test "atomize keys with only option" do
    test_map = %{
      "key" => %{
        "nested" => "value"
      }
    }

    test_result = %{
      "key" => %{
        nested: "value"
      }
    }

    assert Cldr.Map.atomize_keys(test_map, only: "nested") == test_result
    assert Cldr.Map.atomize_keys(test_map, only: ["nested"]) == test_result
    assert Cldr.Map.atomize_keys(test_map, only: &(&1 == "nested")) == test_result

    assert Cldr.Map.atomize_keys(test_map, except: "key") == test_result
    assert Cldr.Map.atomize_keys(test_map, except: ["key"]) == test_result
    assert Cldr.Map.atomize_keys(test_map, except: &(&1 == "key")) == test_result
  end
end
