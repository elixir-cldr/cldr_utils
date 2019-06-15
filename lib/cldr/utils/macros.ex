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
end
