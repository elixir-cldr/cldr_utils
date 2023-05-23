defmodule Support.Map.Test do
  use ExUnit.Case, async: true

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
    assert Cldr.Map.atomize_keys(test_map, only: &(elem(&1, 0) == "nested")) == test_result

    assert Cldr.Map.atomize_keys(test_map, except: "key") == test_result
    assert Cldr.Map.atomize_keys(test_map, except: ["key"]) == test_result
    assert Cldr.Map.atomize_keys(test_map, except: &(elem(&1, 0) == "key")) == test_result
  end

  test "atomizing values when the value is a list" do
    assert Cldr.Map.atomize_values(%{"key" => ["a", "b", "c"]}) == %{"key" => [:a, :b, :c]}
  end

  test "deep_map with levels" do
    test_map = %{
      "key" => %{
        "nested" => "value"
      }
    }

    test_result = %{
      key: %{
        "nested" => "value"
      }
    }

    assert Cldr.Map.atomize_keys(test_map, level: 1..1) == test_result
  end

  test "deep_map with :skip" do
    test_map = %{
      "key" => %{
        "nested" => %{
          "some" => "value"
        }
      }
    }

    test_result = %{
      key: %{
        :nested => %{
          "some" => "value"
        }
      }
    }

    assert Cldr.Map.atomize_keys(test_map, skip: "nested") == test_result
  end

  test "deep_map with :reject" do
    test_map = %{
      "key" => %{
        "nested" => "value"
      }
    }

    test_result = %{
      key: %{}
    }

    assert Cldr.Map.atomize_keys(test_map, reject: "nested") == test_result
  end

  test "Cldr.Map.extract_strings/2" do
    assert Cldr.Map.extract_strings(%{a: "string", b: :atom, c: "Another string"}) |> Enum.sort() ==
      ["Another string", "string"]

    assert Cldr.Map.extract_strings(%{a: "string", b: %{c: "Another string"}}) |> Enum.sort() ==
      ["Another string", "string"]

    assert Cldr.Map.extract_strings(%{a: "string", b: [:c, "Another string"]}) |> Enum.sort() ==
      ["Another string", "string"]
  end

end
