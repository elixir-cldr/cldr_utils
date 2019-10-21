# Cldr Utils

Utility functions extracted from [cldr](https://github,com/kipcole9/cldr)

* Map functions for deep mapping, deep merging, transforming keys
* Math functions including `mod/2` that works on floored division
* Number functions for working with the number of digits, the fraction as an integer, ...
* String function for underscoring (converting CamelCase to snake case)
* Various macros

## Installation

The package can be installed by adding `cldr_utils` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cldr_utils, "~> 2.0"}
  ]
end
```


