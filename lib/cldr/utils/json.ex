if Code.ensure_loaded?(:json) do
  defmodule Cldr.Json do
    @moduledoc """
    A wrapper for the OTP 27 :json module.

    It implements a `decode!/1` function that wraps
    `:json.decode/1`  with `decode!/1` so that its
    compatible with the calling conventions of
    Elixir - which is used by `ex_cldr`.

    This allows configuration such as:
    ```elixir
    config :ex_cldr,
      json_library: Cldr.Json
    ```

    """

    def decode!(string) do
      :json.decode(string)
    end

  end
end