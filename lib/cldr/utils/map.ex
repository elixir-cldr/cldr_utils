defmodule Cldr.Map do
  @moduledoc """
  Functions for transforming maps, keys and values.
  """

  @default_deep_map_options [level: 1..1_000_000]
  @starting_level 1
  @max_level 1_000_000

  @doc """
  Recursively traverse a map and invoke a function for each key/
  value pair that transforms the map.

  ## Arguments

  * `map` is any `t:map/0`

  * `function` is a function or function reference that
    is called for each key/value pair of the provided map

  * `options` is a keyword list of options

  ## Options

  * `:level` indicates the starting (and optionally ending) levels of
    the map at which the `function` is executed. This can
    be an integer representing all levels from `level` or a range
    indicating a range of levels. The default is `1..#{@max_level}`

  ## Returns

  * The `map` transformed by the recursive application of
    `function`

  ## Example

    iex> map = %{a: "a", b: %{c: "c"}}
    iex> Cldr.Map.deep_map map, fn
    ...>   {k, v} when is_binary(v) -> {k, String.upcase(v)}
    ...>   other -> other
    ...> end
    %{a: "A", b: %{c: "C"}}

  """
  @spec deep_map(map() | list(), function :: function() | {function(), function()}, options :: list() | map()) ::
    map() | list()

  def deep_map(map, function, options \\ @default_deep_map_options)

  # Don't deep map structs since they have atom keys anyway and they
  # also don't support enumerable
  def deep_map(%_struct{} = map, _function, _options) when is_map(map) do
    map
  end

  def deep_map(map_or_list, function, options)
      when is_map(map_or_list) or is_list(map_or_list) and is_list(options) do
    options =
      (@default_deep_map_options ++ options)
      |> Map.new()
      |> Map.update!(:level, fn
        level when is_integer(level) -> level..@max_level
        %Range{} = level -> level
        other -> raise ArgumentError, "Level must be an integer or a range. Found #{inspect other}"
      end)

    deep_map(map_or_list, function, options, @starting_level)
  end

  defp deep_map(nil, _fun, _options, _level) do
    nil
  end

  defp deep_map(map_or_list, _function, %{level: %{last: last}}, level)
      when level > last do
    map_or_list
  end

  defp deep_map(map, function, %{level: %{first: first}} = options, level)
      when is_map(map) and is_function(function) and level < first do
    Enum.map(map, fn
      {k, v} when is_map(v) or is_list(v) ->
        {k, deep_map(v, function, options, level + 1)}

      {k, v} ->
        {k, v}
    end)
    |> Map.new
  end

  defp deep_map(map, {key_function, value_function}, %{level: %{first: first}} = options, level)
      when is_map(map) and level < first do
    Enum.map(map, fn
      {k, v} when is_map(v) or is_list(v) ->
        {k, deep_map(v, {key_function, value_function}, options, level + 1)}

      {k, v} ->
        {k, v}
    end)
    |> Map.new
  end

  defp deep_map(map, function, options, level) when is_map(map) and is_function(function) do
    Enum.map(map, fn
      {k, v} when is_map(v) or is_list(v) ->
        function.({k, deep_map(v, function, options, level + 1)})

      {k, v} ->
        function.({k, v})
    end)
    |> Map.new
  end

  defp deep_map(map, {key_function, value_function}, options, level) when is_map(map) do
    Enum.map(map, fn
      {k, v} when is_map(v) or is_list(v) ->
        {key_function.(k), deep_map(v, {key_function, value_function}, options, level + 1)}

      {k, v} ->
        {key_function.(k), value_function.(v)}
    end)
    |> Map.new
  end

  defp deep_map([head | rest], function, options, level) when is_function(function) do
    [deep_map(head, function, options, level + 1) | deep_map(rest, function, options, level + 1)]
  end

  defp deep_map([head | rest], {key_function, value_function}, options, level) do
    [deep_map(head, {key_function, value_function}, options, level + 1) |
     deep_map(rest, {key_function, value_function}, options, level + 1)]
  end

  defp deep_map(value, function, _options, _level) when is_function(function) do
    function.(value)
  end

  defp deep_map(value, {_key_function, value_function}, _options, _level) do
    value_function.(value)
  end

  @doc """
  Transforms a `map`'s `String.t` keys to `atom()` keys.

  * `map` is any `t:map/0`

  * `options` is a keyword list of options.  The
    available option is:

    * `:only_existing` which is set to `true` will
      only convert the binary key to an atom if the atom
      already exists.  The default is `false`.

  ## Examples

  """
  @default_atomize_options [only_existing: false]
  def atomize_keys(map, options \\ []) do
    options = (@default_atomize_options ++ options)
    deep_map(map, &atomize_key(&1, Map.new(options)), options)
  end

  @doc """
  Transforms a `map`'s `String.t` values to `atom()` values.

  * `map` is any `t:map/0`

  * `options` is a keyword list of options.  The
    available option is:

    * `:only_existing` which is set to `true` will
      only convert the binary value to an atom if the atom
      already exists.  The default is `false`.

  ## Examples

  """
  def atomize_values(map, options \\ [only_existing: false]) do
    options = (@default_atomize_options ++ options)
    deep_map(map, &atomize_value(&1, Map.new(options)), options)
  end

  @doc """
  Transforms a `map`'s `atom()` keys to `String.t` keys.

  * `map` is any `t:map/0`

  ## Examples

  """
  def stringify_keys(map) do
    deep_map(
      map,
      fn
        k when is_atom(k) -> Atom.to_string(k)
        k -> k
      end,
      &identity/1
    )
  end

  @doc """
  Transforms a `map`'s keys to `Integer.t` keys.

  * `map` is any `t:map/0`

  The map key is converted to an `integer` from
  either an `atom` or `String.t` only when the
  key is comprised of `integer` digits.

  Keys which cannot be converted to an `integer`
  are returned unchanged.

  ## Examples

  """
  def integerize_keys(map, options \\ []) do
    deep_map(map, &integerize_key(&1, Map.new(options)), options)
  end

  @doc """
  Transforms a `map`'s values to `Integer.t` values.

  * `map` is any `t:map/0`

  The map value is converted to an `integer` from
  either an `atom` or `String.t` only when the
  value is comprised of `integer` digits.

  Keys which cannot be converted to an integer
  are returned unchanged.

  ## Examples

  """
  def integerize_values(map, options \\ []) do
    deep_map(map, &integerize_value(&1, Map.new(options)), options)
  end

  @doc """
  Transforms a `map`'s keys to `Float.t` values.

  * `map` is any `t:map/0`

  The map key is converted to a `float` from
  either an `atom` or `String.t` only when the
  key is comprised of a valid float form.

  Keys which cannot be converted to a `float`
  are returned unchanged.

  ## Examples

  """
  def floatize_keys(map) do
    deep_map(map, &floatize_key/1)
  end

  @doc """
  Transforms a `map`'s values to `Float.t` values.

  * `map` is any `t:map/0`

  The map value is converted to a `float` from
  either an `atom` or `String.t` only when the
  value is comprised of a valid float form.

  Values which cannot be converted to a `float`
  are returned unchanged.

  ## Examples

  """
  def floatize_values(map) do
    deep_map(map, &floatize_value/1)
  end

  @doc """
  Rename map keys from `from` to `to`

  * `map` is any `t:map/0`

  * `from` is any value map key

  * `to` is any valud map key

  ## Examples

  """
  def rename_key(map, from, to) do
    deep_map(
      map,
      fn
        ^from -> to
        other -> other
      end,
      &identity/1
    )
  end

  @doc """
  Convert map keys from `camelCase` to `snake_case`

  * `map` is any `t:map/0`

  ## Examples

  """
  def underscore_keys(map, options \\ []) when is_map(map) or is_nil(map) do
    deep_map(map, &underscore_key(&1, Map.new(options)), options)
  end

  @doc """
  Removes any leading underscores from `map`
  keys.

  * `map` is any `t:map/0`

  ## Examples

  """
  def remove_leading_underscores(map) do
    deep_map(map, {&String.replace_prefix(&1, "_", ""), &identity/1})
  end

  @doc """
  Returns the result of deep merging a list of maps

  ## Examples

      iex> Cldr.Map.merge_map_list [%{a: "a", b: "b"}, %{c: "c", d: "d"}]
      %{a: "a", b: "b", c: "c", d: "d"}

  """
  def merge_map_list([h | []]) do
    h
  end

  def merge_map_list([h | t]) do
    deep_merge(h, merge_map_list(t))
  end

  def merge_map_list([]) do
    []
  end

  @doc """
  Deep merge two maps

  * `left` is any `t:map/0`

  * `right` is any `t:map/0`

  ## Examples

      iex> Cldr.Map.deep_merge %{a: "a", b: "b"}, %{c: "c", d: "d"}
      %{a: "a", b: "b", c: "c", d: "d"}

      iex> Cldr.Map.deep_merge %{a: "a", b: "b"}, %{c: "c", d: "d", a: "aa"}
      %{a: "aa", b: "b", c: "c", d: "d"}

  """
  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end

  @doc """
  Delete all members of a map that have a
  key in the list of keys

  ## Examples

      iex> Cldr.Map.delete_in %{a: "a", b: "b"}, [:a]
      %{b: "b"}

  """
  def delete_in(%{} = map, keys) when is_list(keys) do
    Enum.reject(map, fn {k, _v} -> k in keys end)
    |> Enum.map(fn {k, v} -> {k, delete_in(v, keys)} end)
    |> Map.new
  end

  def delete_in(map, keys) when is_list(map) and is_binary(keys) do
    delete_in(map, [keys])
  end

  def delete_in(map, keys) when is_list(map) do
    Enum.reject(map, fn {k, _v} -> k in keys end)
    |> Enum.map(fn {k, v} -> {k, delete_in(v, keys)} end)
  end

  def delete_in(%{} = map, keys) when is_binary(keys) do
    delete_in(map, [keys])
  end

  def delete_in(other, _keys) do
    other
  end

  def from_keyword(keyword) do
    Enum.into(keyword, %{})
  end

  defp identity(x), do: x

  defp atomize_key({k, v}, %{only_existing: true} = options) when is_binary(k) do
    if process_element?({k, v}, options) do
      {String.to_existing_atom(k), v}
    else
      {k, v}
    end

  rescue
    ArgumentError ->
      {k, v}
  end

  defp atomize_key({k, v}, %{only_existing: false} = options) when is_binary(k) do
    if process_element?({k, v}, options) do
      {String.to_atom(k), v}
    else
      {k, v}
    end
  end

  defp atomize_key(x, _options) do
    x
  end

  def atomize_value({k, v}, %{only_existing: true} = options) when is_binary(v) do
    if process_element?({k, v}, options) do
      {k, String.to_existing_atom(v)}
    else
      {k, v}
    end

  rescue
    ArgumentError ->
      {k, v}
  end

  def atomize_value({k, v}, %{only_existing: false} = options) when is_binary(v) do
    if process_element?({k, v}, options) do
      {k, String.to_atom(v)}
    else
      {k, v}
    end
  end

  def atomize_value(v, %{only_existing: false}) when is_binary(v) do
    String.to_atom(v)
  end

  def atomize_value(x, _) do
    x
  end

  @integer_reg Regex.compile!("^-?[0-9]+$")
  defp integerize_key({k, v}, options) when is_binary(k) do
    if process_element?(k, options) && Regex.match?(@integer_reg, k) do
      {String.to_integer(k), v}
    else
      {k, v}
    end
  end

  defp integerize_key(x, _options) do
    x
  end

  defp integerize_value({k, v}, options) when is_atom(v) do
    integerize_value({k, Atom.to_string(v)}, options)
  end

  defp integerize_value({k, v}, options) when is_binary(v) do
    if process_element?(k, options) && Regex.match?(@integer_reg, v) do
      {k, String.to_integer(v)}
    else
      {k, v}
    end
  end

  defp integerize_value(x, _options) do
    x
  end

  defp underscore_key({k, v}, options) when is_atom(k) do
    {Atom.to_string(k), v}
    |> underscore_key(options)
  end

  defp underscore_key({k, v}, options) when is_binary(k) do
    if process_element?(k, options) do
      {underscore(k, options), v}
    else
      {k, v}
    end
  end

  defp underscore_key(x, _options) do
    x
  end

  @float_reg Regex.compile!("^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$")
  defp floatize_key({k, v}) when is_atom(k) do
    floatize_key({Atom.to_string(k), v})
  end

  defp floatize_key({k, v}) when is_binary(k) do
    if Regex.match?(@float_reg, k) do
      {String.to_float(k), v}
    else
      {k, v}
    end
  end

  defp floatize_key(x) do
    x
  end

  defp floatize_value({k, v}) when is_atom(v) do
    floatize_value({k, Atom.to_string(v)})
  end

  defp floatize_value({k, v}) when is_binary(v) do
    if Regex.match?(@float_reg, v) do
      {k, String.to_float(v)}
    else
      {k, v}
    end
  end

  defp floatize_value(x) do
    x
  end

  defp process_element?(x, options) do
    only = Map.get(options, :only, []) |> maybe_wrap
    except = Map.get(options, :except, []) |> maybe_wrap
    process_element?(x, only, except)
  end

  def maybe_wrap(element) when is_list(element) do
    element
  end

  def maybe_wrap(element) do
    [element]
  end

  # process_element?/2 determines whether the
  # calling function should apply to a given
  # value
  defp process_element?(_x, [], []) do
    true
  end

  defp process_element?(x, [], [except]) when is_function(except) do
    !except.(x)
  end

  defp process_element?({k, _v}, [], except) do
    k not in except
  end

  defp process_element?(x, [only], []) when is_function(only) do
    only.(x)
  end

  defp process_element?({k, _v}, only, []) do
    k in only
  end

  defp process_element?(x, [only], [except]) when is_function(only) and is_function(except) do
    only.(x) && not except.(x)
  end

  defp process_element?({k, _v} = x, [only], except) when is_function(only) do
    only.(x) && k not in except
  end

  defp process_element?({k, _v} = x, only, [except]) when is_function(except) do
   k in only && !except.(x)
  end

  defp process_element?(x, only, except) do
    x in only and x not in except
  end

  @doc """
  Convert a camelCase string or atome to a snake_case

  * `string` is a `String.t` or `atom()` to be
    transformed

  This is the code of Macro.underscore with modifications.
  The change is to cater for strings in the format:

    This_That

  which in Macro.underscore gets formatted as

    this__that (note the double underscore)

  when we actually want

    that_that

  ## Examples

  """
  @spec underscore(string :: String.t() | atom(), options :: map()) :: String.t()
  def underscore(atom, options) when is_atom(atom) do
    "Elixir." <> rest = Atom.to_string(atom)
    underscore(rest, options)
  end

  def underscore(<<h, t::binary>> = string, options) do
    if process_element?(string, options) do
      <<to_lower_char(h)>> <> do_underscore(t, h, options)
    end
  end

  def underscore("", _options) do
    ""
  end

  # h is upper case, next char is not uppercase, or a _ or .  => and prev != _
  defp do_underscore(<<h, t, rest::binary>>, prev, options)
       when h >= ?A and h <= ?Z and not (t >= ?A and t <= ?Z) and t != ?. and t != ?_ and t != ?- and
              prev != ?_ do
    <<?_, to_lower_char(h), t>> <> do_underscore(rest, t, options)
  end

  # h is uppercase, previous was not uppercase or _
  defp do_underscore(<<h, t::binary>>, prev, options)
       when h >= ?A and h <= ?Z and not (prev >= ?A and prev <= ?Z) and prev != ?_ do
    <<?_, to_lower_char(h)>> <> do_underscore(t, h, options)
  end

  # h is dash "-" -> replace with underscore "_"
  defp do_underscore(<<?-, t::binary>>, _, options) do
    <<?_>> <> underscore(t, options)
  end

  # h is .
  defp do_underscore(<<?., t::binary>>, _, options) do
    <<?/>> <> underscore(t, options)
  end

  # Any other char
  defp do_underscore(<<h, t::binary>>, _, options) do
    <<to_lower_char(h)>> <> do_underscore(t, h, options)
  end

  defp do_underscore(<<>>, _, _) do
    <<>>
  end

  def to_upper_char(char) when char >= ?a and char <= ?z, do: char - 32
  def to_upper_char(char), do: char

  def to_lower_char(char) when char == ?-, do: ?_
  def to_lower_char(char) when char >= ?A and char <= ?Z, do: char + 32
  def to_lower_char(char), do: char
end
