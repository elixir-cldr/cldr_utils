defmodule Support.Macro.Test do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  test "warn once" do
    assert capture_log(fn ->
             defmodule M do
               import Cldr.Macros
               warn_once(:a, "Here we are")
             end
           end) =~ "Here we are"
  end
end
