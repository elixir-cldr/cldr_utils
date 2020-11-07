defmodule Cldr.Http.Test do
  use ExUnit.Case


  test "Downloading an https url" do
    assert {:ok, _body} = Cldr.Http.get("https://google.com")
  end

end