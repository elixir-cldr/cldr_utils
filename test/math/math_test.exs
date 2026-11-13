defmodule Math.Test do
  use ExUnit.Case, async: true

  alias Cldr.Math
  alias Cldr.Digits

  use ExUnitProperties

  property "check rounding for decimals is the same as Decimal.round/3" do
    check all(decimal <- GenerateNumber.decimal(), max_runs: 1_000) do
      assert Decimal.round(decimal, 0, :half_up) == Cldr.Math.round(decimal, 0, :half_up)
    end
  end

  property "check rounding to zero places for floats is the same as Kernel.round/1" do
    check all(float <- GenerateNumber.float(), max_runs: 1_000) do
      assert Kernel.round(float) == Cldr.Math.round(float, 0, :half_up)
    end
  end

  property "check rounding to zero places for floats is the same as Float.round/1" do
    check all(float <- GenerateNumber.float(), max_runs: 1_000) do
      assert Float.round(float) == Cldr.Math.round(float, 0, :half_up)
    end
  end

  test "integer number of digits for a decimal integer" do
    decimal = Decimal.new(1234)
    assert Digits.number_of_integer_digits(decimal) == 4
  end

  test "rounding floats" do
    assert Cldr.Math.round(1.401, 2, :half_even) == 1.4
    assert Cldr.Math.round(1.404, 2, :half_even) == 1.4
    assert Cldr.Math.round(1.405, 2, :half_even) == 1.4
    assert Cldr.Math.round(1.406, 2, :half_even) == 1.41
  end

  test "rounding floats with zero decimals" do
    assert Cldr.Math.round(3.6000000000000085) == 4.0
  end

  test "rounding a float < 0 with zero decimals" do
    assert Cldr.Math.round(0.959999999999809) == 1.0
  end

  test "integer number of digits for a decimal fixnum" do
    decimal = Decimal.from_float(1234.5678)
    assert Digits.number_of_integer_digits(decimal) == 4
  end

  test "rounding decimal number" do
    decimal = Decimal.new("0.1111") |> Cldr.Math.round()
    assert Decimal.equal?(decimal, Decimal.new(0))
    assert decimal.sign == 1
  end

  @decimals [Decimal.new("0.9876"), Decimal.new("1.9876"), Decimal.new("0.4"), Decimal.new("0.6")]
  @places [0, 1, 2, 3]
  @rounding [:half_even, :floor, :ceiling, :half_up, :half_down]
  for d <- @decimals, p <- @places, r <- @rounding do
    test "default rounding is the same as Decimal.round for #{inspect(d)}, places: #{inspect(p)}, mode: #{
           inspect(r)
         }" do
      assert Cldr.Math.round(unquote(Macro.escape(d)), unquote(p), unquote(r)) ==
               Decimal.round(unquote(Macro.escape(d)), unquote(p), unquote(r))
    end
  end

  test "round significant digits returns a decimal unchanged for zero or fewer digits" do
    for string <- ["7", "-7", "1.5", "-0.5", "0", "123456789.123"], digits <- [0, -1] do
      decimal = Decimal.new(string)
      assert Math.round_significant(decimal, digits) == decimal
    end
  end

  test "round significant digits returns zero unchanged" do
    assert Math.round_significant(0, 3) === 0
    assert Math.round_significant(0.0, 3) === 0.0
    assert Math.round_significant(-0.0, 3) === -0.0
    assert Math.round_significant(Decimal.new("0"), 3) == Decimal.new("0")
    assert Math.round_significant(Decimal.new("-0"), 3) == Decimal.new("-0")
    assert Math.round_significant(Decimal.new("0.00"), 3) == Decimal.new("0.00")
  end

  test "round significant digits returns NaN and infinite decimals unchanged" do
    for string <- ["NaN", "Infinity", "-Infinity"], digits <- [0, 3] do
      decimal = Decimal.new(string)
      assert Math.round_significant(decimal, digits) == decimal
    end
  end

  test "round significant digits still rounds non-zero numbers" do
    assert Math.round_significant(1234, 2) === 1200
    assert Math.round_significant(-1234, 2) === -1200
    assert Math.round_significant(3.14159, 3) === 3.14
    assert Math.round_significant(1234, 0) === 1234

    assert Decimal.equal?(Math.round_significant(Decimal.new("-1234"), 2), Decimal.new("-1200"))
    assert Decimal.equal?(Math.round_significant(Decimal.new("0.00012345"), 2), Decimal.new("0.00012"))
  end

  if Code.ensure_loaded?(Decimal) && function_exported?(Decimal, :normalize, 1) do
    test "round significant digits for a decimal integer" do
      decimal = Decimal.new(1234)
      assert Math.round_significant(decimal, 2) == Decimal.normalize(Decimal.new(1200))
    end

    test "round significant digits for a decimal" do
      decimal = Decimal.from_float(1234.45)
      assert Math.round_significant(decimal, 4) == Decimal.normalize(Decimal.new(1234))
    end

    test "round significant digits for a decimal to 5 digits" do
      decimal = Decimal.from_float(1234.45)
      assert Math.round_significant(decimal, 5) == Decimal.normalize(Decimal.from_float(1234.5))
    end
  else
    test "round significant digits for a decimal integer" do
      decimal = Decimal.new(1234)
      assert Math.round_significant(decimal, 2) == Decimal.reduce(Decimal.new(1200))
    end

    test "round significant digits for a decimal" do
      decimal = Decimal.from_float(1234.45)
      assert Math.round_significant(decimal, 4) == Decimal.reduce(Decimal.new(1234))
    end

    test "round significant digits for a decimal to 5 digits" do
      decimal = Decimal.from_float(1234.45)
      assert Math.round_significant(decimal, 5) == Decimal.reduce(Decimal.from_float(1234.5))
    end
  end

  test "power of 0 == 1" do
    assert Math.power(Decimal.new(123), 0) == Decimal.new(1)
  end

  test "power of decimal where n > 1" do
    assert Math.power(Decimal.new(12), 3) == Decimal.new(1728)
  end

  test "power of decimal where n < 0" do
    assert Math.power(Decimal.new(4), -2) == Decimal.from_float(0.0625)
  end

  test "power of decimal where number < 0" do
    assert Math.power(Decimal.new(-4), 2) == Decimal.new(16)
  end

  test "power of integer when n = 0" do
    assert Math.power(3, 0) === 1
  end

  test "power of float when n == 0" do
    assert Math.power(3.0, 0) === 1.0
  end

  test "power of integer when n < 1" do
    assert Math.power(4, -2) == 0.0625
  end

  test "amod returns the divisor when it the remainder would be zero and test that dividend is one less" do
    {div, amod} = Cldr.Math.div_amod(24, 12)
    assert amod == 12
    assert div == 1
  end

  test "amod returns the zero for the remainder" do
    {div, mod} = Cldr.Math.div_mod(24, 12)
    assert mod == 0
    assert div == 2
  end
end
