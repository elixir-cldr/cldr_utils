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

  test "Request with headers" do
    assert {:ok, _body} = Cldr.Http.get({"https://google.com", [{'Accept-Language', '*'}]})
  end

  test "Request with headers and no peer verification" do
    assert {:ok, _body} = Cldr.Http.get({"https://google.com", [{'Accept-Language', '*'}]}, verify_peer: false)
  end

  test "Request with headers returning headers" do
    assert {:ok, _headers, _body} = Cldr.Http.get_with_headers({"https://google.com", [{'Accept-Language', '*'}]})
  end

  test "Request with connection timeout" do
    options = [connection_timeout: 5]

    assert capture_log(fn ->
      assert {:error, :connection_timeout} =
        Cldr.Http.get_with_headers({"https://google.com", [{'Accept-Language', '*'}]}, options)
    end) =~ "Timeout connecting to 'google.com'"
  end

  test "Request with timeout" do
    options = [timeout: 5]

    assert capture_log(fn ->
      assert {:error, :timeout} =
        Cldr.Http.get_with_headers({"https://google.com", [{'Accept-Language', '*'}]}, options)
    end) =~ "Timeout downloading from 'https://google.com'. Request exceeded #{inspect options[:timeout]}ms."
  end

end