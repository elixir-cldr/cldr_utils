defmodule Math.Log.Test do
  use ExUnit.Case, async: false

  # Pin tests to a fixed Decimal.Context precision so high-precision fixtures
  # remain stable across Decimal versions whose default precision differs
  # (Decimal 2.x defaults to 28; Decimal 3.0 defaults to 34) and so rendered
  # results round-trip through `Decimal.new/1`, whose parser caps the digit
  # count at the active context's max digits.
  @precision 28

  setup do
    original = Decimal.Context.get()
    Decimal.Context.set(%{original | precision: @precision})
    on_exit(fn -> Decimal.Context.set(original) end)
    :ok
  end

  @round 2
  @samples [
    {1, 0},
    {10, 2.30258509299},
    {1.23004, 0.20704668918075508}
  ]

  Enum.each(@samples, fn {sample, result} ->
    test "that decimal log(e) is correct for #{inspect(sample)}" do
      calc = Cldr.Math.log(Decimal.new(unquote(to_string(sample)))) |> Decimal.round(@round)
      sample = Decimal.new(unquote(to_string(result))) |> Decimal.round(@round)
      assert Cldr.Decimal.compare(calc, sample) == :eq
    end
  end)

  random =
    for _i <- 1..500 do
      :rand.uniform(10000) / 10
    end
    |> Enum.uniq()

  @diff 0.005
  Enum.each(random, fn x ->
    test "that decimal log(e) is more or less the same as bif log(e) for #{inspect(x)}" do
      assert :math.log(unquote(x)) -
               Cldr.Math.to_float(Cldr.Math.log(Decimal.new(unquote(to_string(x))))) <
               @diff
    end
  end)

  # Testing large decimals that are beyond the precision of a float.
  # Expected value is the 28-significant-digit log of 1.333..., matching the
  # pinned `@precision` of this test module.
  test "log Decimal.new(\"1.33333333333333333333333333333333\")" do
    assert Cldr.Decimal.compare(
             Cldr.Math.log(Decimal.new("1.33333333333333333333333333333333")),
             Decimal.new("0.2876820724291554672132526174")
           ) == :eq
  end
end
