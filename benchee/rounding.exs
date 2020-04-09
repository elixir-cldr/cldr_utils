float = 3.14159762
decimal = Decimal.new("3.14159762")
Benchee.run(%{
  "Float"  => fn -> Cldr.Math.round(float, 2) end,
  "Decimal" => fn -> Decimal.round(decimal, 2) end,
  "Float to Decimal" => fn -> Cldr.Math.round(Decimal.from_float(float), 2) end
  })