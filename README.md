![Build Status](http://sweatbox.noexpectations.com.au:8080/buildStatus/icon?job=cldr_utils)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_calendars.svg)](https://hex.pm/packages/cldr_utils)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_calendars.svg?)](https://hex.pm/packages/cldr_utils)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_calendars.svg)](https://hex.pm/packages/cldr_utils)

# Cldr Utils

Utility functions extracted from [cldr](https://github.com/elixir-cldr/cldr)

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


