defmodule Cldr.Macros do
  @moduledoc false

  defmacro is_false(value) do
    quote do
      is_nil(unquote(value)) or unquote(value) == false
    end
  end

  defmacro doc_since(version) do
    if Version.match?(System.version(), ">= 1.7.0") do
      quote do
        @doc since: unquote(version)
      end
    end
  end

  defmacro calendar_impl do
    if Version.match?(System.version(), ">= 1.10.0-dev") do
      quote do
        @impl true
      end
    end
  end

  defmacro warn_once(key, message, level \\ :warn) do
    caller = __CALLER__.module

    quote do
      require Logger

      ck = {unquote(caller), unquote(key)}

      missing? =
        if function_exported?(:persistent_term, :get, 2) do
          apply(:persistent_term, :get, [ck, true])
          # :persistent_term.get(ck, true)
        else
          try do
            :persistent_term.get(ck)
          rescue
            ArgumentError -> true
          end
        end

      if missing? do
        Logger.unquote(level)(unquote(message))
        :persistent_term.put(ck, nil)
      end
    end
  end
end
