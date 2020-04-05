defmodule Warn.Test do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  test "warn once" do
    import Cldr.Macros

    assert capture_log(fn ->
             warn_once("aaa", "this is the warning message")
           end) =~ "this is the warning message"

    assert capture_log(fn ->
             warn_once("aaa", "this should not appear")
           end) == ""
  end
end
