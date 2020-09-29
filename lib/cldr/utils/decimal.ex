defmodule Cldr.Decimal do
  @moduledoc """
  Adds a compatibility layer for functions which changed
  either semantics or returns types between Decimal version
  1.x and 2.x

  """
  decimal_version = Keyword.get(Application.spec(:decimal), :vsn) |> List.to_string

  # To cater for both Decimal 1.x and 2.x
  if Code.ensure_loaded?(Decimal) && function_exported?(Decimal, :normalize, 1) do
    def reduce(decimal) do
      Decimal.normalize(decimal)
    end
  else
    def reduce(decimal) do
      Decimal.reduce(decimal)
    end
  end

  def compare(decimal1, decimal2) do
    Cldr.Math.decimal_compare(decimal1, decimal2)
  end

  if Version.match?(decimal_version, "~> 2.0") do
    def parse(string) do
      case Decimal.parse(string) do
        {decimal, ""} -> {decimal, ""}
        _other -> {:error, string}
      end
    end
  else
    def parse(string) do
      case Decimal.parse(string) do
        {:ok, decimal} -> {decimal, ""}
        _other -> {:error, string}
      end
    end
  end
end