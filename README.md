# Cldr Utils

![Build Status](http://sweatbox.noexpectations.com.au:8080/buildStatus/icon?job=cldr_utils)
[![Module Version](https://img.shields.io/hexpm/v/cldr_utils.svg)](https://hex.pm/packages/cldr_utils)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/cldr_utils/)
[![Total Download](https://img.shields.io/hexpm/dt/cldr_utils.svg)](https://hex.pm/packages/cldr_utils)
[![License](https://img.shields.io/hexpm/l/cldr_utils.svg)](https://github.com/elixir-cldr/cldr_utils/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/elixir-cldr/cldr_utils.svg)](https://github.com/elixir-cldr/cldr_utils/commits/master)

Utility functions extracted from [Cldr](https://github.com/elixir-cldr/cldr).

* Map functions for deep mapping, deep merging, transforming keys
* Math functions including `mod/2` that works on floored division
* Number functions for working with the number of digits, the fraction as an integer, ...
* String function for underscoring (converting CamelCase to snake case)
* Various macros

## Installation

The package can be installed by adding `:cldr_utils` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cldr_utils, "~> 2.0"}
  ]
end
```

## Benchmark

To run the benchmark:

```bash
$ mix run benchee/decimal.exs
```

## Copyright and License

Copyright (c) 2017 Kip Cole

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
