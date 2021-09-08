defmodule Cldr.Calendar.Conversion do
  @moduledoc false

  # This is a private module used only
  # by ex_cldr during the consolidation phase
  # of the CLDR base data

  def convert_eras_to_iso_days(calendar_data) do
    Enum.map(calendar_data, fn {calendar, content} ->
      {calendar, adjust_eras(content)}
    end)
    |> Enum.into(%{})
  end

  defp adjust_eras(%{"eras" => eras} = content) do
    eras =
      eras
      |> Enum.map(fn {era, dates} -> {era, adjust_era(dates)} end)
      |> Enum.into(%{})

    Map.put(content, "eras", eras)
  end

  defp adjust_eras(%{} = content) do
    content
  end

  defp adjust_era(dates) do
    IO.inspect dates
    Enum.map(dates, fn
      {"start", date} -> {"start", to_iso_days(date)}
      {"end", date} -> {"end", to_iso_days(date)}
      {k, v} -> {k, v}
    end)
    |> Enum.into(%{})
  end

  def parse_time_periods(period_data) do
    Enum.map(period_data, fn {language, periods} ->
      {language, adjust_periods(periods)}
    end)
    |> Enum.into(%{})
  end

  defp adjust_periods(periods) do
    Enum.map(periods, fn {period, times} ->
      {period, adjust_times(times)}
    end)
    |> Enum.into(%{})
  end

  defp adjust_times(times) do
    Enum.map(times, fn {key, time} ->
      {key, Enum.map(String.split(time, ":"), &String.to_integer/1)}
    end)
    |> Enum.into(%{})
  end

  def to_iso_days(%{year: year, month: month, day: day}) do
    [year, month, day]
  end

  def to_iso_days(date) when is_binary(date) do
    {year, month, day} =
      case String.split(date, "-") do
        [year, month, day] ->
          {String.to_integer(year), String.to_integer(month), String.to_integer(day)}

        ["", year, month, day] ->
          {String.to_integer("-#{year}"), String.to_integer(month), String.to_integer(day)}
      end

    [year, month, day]
  end


end
