defmodule Cldr.Helpers do
  def empty?([]), do: true
  def empty?(%{} = map) when map == %{}, do: true
  def empty?(nil), do: true
  def empty?(_), do: false

  cond do
    function_exported?(:persistent_term, :get, 2) ->
      @doc false
      def get_term(key, default) do
        :persistent_term.get(key, default)
      end

      def put_term(key, value) do
        :persistent_term.put(key, value)
      end

    function_exported?(:persistent_term, :get, 1) ->
       @doc false
       def get_term(key, default) do
         :persistent_term.get(key)
       rescue ArgumentError ->
         default
       end

       def put_term(key, value) do
         :persistent_term.put(key, value)
       end
    true ->
      def get_term(_key, default) do
        default
      end

      def put_term(key, value) do
        value
      end
  end
end
