defmodule Cldr.Http.Test do
  use ExUnit.Case
  import ExUnit.CaptureLog

  test "Downloading an https url" do
    assert {:ok, _body} = Cldr.Http.get("https://google.com")
  end

  test "Downloading an https url and return headers" do
    assert {:ok, _headers, _body} = Cldr.Http.get_with_headers("https://google.com")
  end

  test "Downloading an unknown url" do
    capture_log(fn ->
      assert {:error, :nxdomain} = Cldr.Http.get("https://zzzzzzzzzzzzzzzz.com")
    end) =~ "Failed to connect to 'zzzzzzzzzzzzzzzz.com'"
  end

end