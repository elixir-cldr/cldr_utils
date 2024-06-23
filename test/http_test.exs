defmodule Cldr.Http.Test do
  use ExUnit.Case
  import ExUnit.CaptureLog

  @accept_language String.to_charlist("Accept-Language")
  @any String.to_charlist("*")

  test "Downloading an https url" do
    assert {:ok, _body} = Cldr.Http.get("https://google.com")
  end

  test "Downloading an https url and return headers" do
    assert {:ok, _headers, _body} = Cldr.Http.get_with_headers("https://google.com")
  end

  test "Downloading an unknown url" do
    capture_log(fn ->
      assert {:error, :nxdomain} = Cldr.Http.get("https://xzzzzzzzzzzzzzzzz.com")
    end) =~ "Failed to connect to 'xzzzzzzzzzzzzzzzz.com'"
  end

  test "Request with headers" do
    assert {:ok, _body} = Cldr.Http.get({"https://google.com", [{@accept_language, @any}]})
  end

  test "Request with headers and no peer verification" do
    assert {:ok, _body} = Cldr.Http.get({"https://google.com", [{@accept_language, @any}]}, verify_peer: false)
  end

  test "Request with headers returning headers" do
    assert {:ok, _headers, _body} = Cldr.Http.get_with_headers({"https://google.com", [{@accept_language, @any}]})
  end

  if Version.compare(System.version(), "1.14.9") == :gt do
    test "Request with connection timeout" do

      options = [connection_timeout: 2]

      assert capture_log(fn ->
        assert {:error, :connection_timeout} =
          Cldr.Http.get_with_headers({"https://google.com", [{@accept_language, @any}]}, options)
      end) =~ "Timeout connecting to"
    end

    test "Request with timeout" do
      options = [timeout: 2]

      assert capture_log(fn ->
        assert {:error, :timeout} =
          Cldr.Http.get_with_headers({"https://google.com", [{@accept_language, @any}]}, options)
      end) =~ "Timeout downloading from"
    end
  end
end