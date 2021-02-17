defmodule Math.Power.Test do
  use ExUnit.Case, async: true

  @significance 15

  # On my machine, iterations over 12 bring bad karma
  @iterations 12

  Enum.each(-10..@iterations, fn n ->
    test "Confirm Cldr.Math.power(5, n) for #{inspect(n)} returns the same result as :math.pow" do
      p =
        Cldr.Math.power(5, unquote(n))
        |> Cldr.Math.round_significant(@significance)

      q =
        :math.pow(5, unquote(n))
        |> Cldr.Math.round_significant(@significance)

      assert p == q
    end

    # Decimal number, decimal power
    test "Confirm Decimal Cldr.Math.power(5, n) for Decimal #{inspect(n)} returns the same result as :math.pow" do
      p =
        Cldr.Math.power(Decimal.new(5), Decimal.new(unquote(n)))
        |> Cldr.Math.round_significant(10)
        |> Decimal.to_float()

      q =
        :math.pow(5, unquote(n))
        |> Cldr.Math.round_significant(10)

      assert p == q
    end
  end)

  test "Short cut decimal power of 10 for a positive number" do
    p = Cldr.Math.power(Decimal.new(10), 2)
    assert Cldr.Decimal.compare(p, Decimal.new(100)) == :eq

    p = Cldr.Math.power(Decimal.new(10), 3)
    assert Cldr.Decimal.compare(p, Decimal.new(1000)) == :eq

    p = Cldr.Math.power(Decimal.new(10), 4)
    assert Cldr.Decimal.compare(p, Decimal.new(10000)) == :eq
  end

  test "Short cut decimal power of 10 for a negative number" do
    p = Cldr.Math.power(Decimal.new(10), -2)
    assert Cldr.Decimal.compare(p, Decimal.new("0.01")) == :eq

    p = Cldr.Math.power(Decimal.new(10), -3)
    assert Cldr.Decimal.compare(p, Decimal.new("0.001")) == :eq

    p = Cldr.Math.power(Decimal.new(10), -4)
    assert Cldr.Decimal.compare(p, Decimal.new("0.0001")) == :eq
  end

  test "A specific bug fix" do
    a = Decimal.new("0.00001232")
    b = Decimal.new("0.00001242")
    x = Decimal.sub(a, b)

    assert Cldr.Decimal.compare(Cldr.Math.power(x, 2), Decimal.new("0.00000000000001")) ==
             :eq
  end
end
