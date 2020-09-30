defmodule Math.Mantissa.Exponent.Test do
  use ExUnit.Case, async: true

  @test [
    1.23004,
    12.345,
    645.978,
    0.00345,
    0.0123,
    0.1,
    -0.1,
    -1,
    0.3,
    0.99,
    0,
    0.0,
    1,
    5,
    10,
    17,
    47,
    107,
    507,
    1000,
    1007,
    2345,
    40000
  ]

  @ten Decimal.new(10)

  Enum.each(@test, fn value ->
    test "Validate coef * 10**exponent == original number of #{inspect(value)}" do
      test_value =
        if is_float(unquote(value)) do
          Decimal.new(unquote(to_string(value)))
        else
          Decimal.new(unquote(Macro.escape(value)))
        end

      # Calculate the mantissa and exponent
      {coef, exponent} = Cldr.Math.coef_exponent(test_value)

      # And then recalculate the decimal value
      calculated_value =
        @ten
        |> Cldr.Math.power(exponent)
        |> Decimal.mult(coef)

      # And confirm we made the round trip
      assert Cldr.Decimal.compare(calculated_value, test_value) == :eq
    end
  end)
end
