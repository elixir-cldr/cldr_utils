## Changelog for Cldr Utils version 2.9.0

This is the changelog for Cldr Utils v2.9.0 released on _______, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Adds `:only` and `:except` options to `Cldr.Map.atomize_keys/3`, `Cldr.Map.atomize_values/3`, `Cldr.Map.integerize_keys/3` and `Cldr.Map.integerize_values/3`

* Adds `:level` option to `Cldr.Map.deep_merge/3`

## Changelog for Cldr Utils version 2.8.0

This is the changelog for Cldr Utils v2.8.0 released on February 14th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Be more resilient of the availability of `:persistent_term` given that `get/2`, `get/1` and `:persistent_term` itself are available on different OTP releases. Thanks to @halostatue. Closes #2.

## Changelog for Cldr Utils version 2.7.0

This is the changelog for Cldr Utils v2.7.0 released on January 31st, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.String.to_underscore/1` the replaces "-" with "_"

## Changelog for Cldr Utils version 2.6.0

This is the changelog for Cldr Utils v2.6.0 released on January 21st, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Support `Decimal` versions `~> 1.6 or 1.9 or 2.0`.  Version 1.9 deprecates `Decimal.compare/2` in favour of `Decimal.cmp/2`. The upcoming `Decimal` version 2.0 deprecates `Decimal.cmp/2` in favour of a new implementation of `Decimal.compare/2` that conforms to Elixir norms and is required to support `Enum.sort/2` correctly.  This version of `cldr_utils` detects the relevant version and adapts accordingly at compile time.

## Changelog for Cldr Utils version 2.5.0

This is the changelog for Cldr Utils v2.5.0 released on October 22nd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Macros.warn_once/3` to log a warning, but only once for a given key

## Changelog for Cldr Utils version 2.4.0

This is the changelog for Cldr Utils v2.4.0 released on August 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.String.hash/1` to implement a polynomial rolling hash function

## Changelog for Cldr Utils version 2.3.0

This is the changelog for Cldr Utils v2.3.0 released on June 15th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Adds `doc_since/1` and `calendar_impl/0` to support conditional compilation based upon Elixir versions

## Changelog for Cldr Utils version 2.2.0

This is the changelog for Cldr Utils v2.2.0 released on March 25th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Math.div_amod/2`

## Changelog for Cldr Utils version 2.1.0

This is the changelog for Cldr Utils v2.1.0 released on March 10th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* `Cldr.Map.integerize_keys/1` now properly processes negative integer keys. Minor version change to make it easier to peg versions in upstream packages.

## Changelog for Cldr Utils version 2.0.5

This is the changelog for Cldr Utils v2.0.4 released on Jnauary 3rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fixes `Cldr.Math.round/3` for floats when rounding is > 0 digits

## Changelog for Cldr Utils version 2.0.4

This is the changelog for Cldr Utils v2.0.4 released on Decmber 15th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fixes `Cldr.Math.round/3` to be compatible with `Decimal.round/3` and `Kernel.round/1`

## Changelog for Cldr Utils version 2.0.3

This is the changelog for Cldr Utils v2.0.3 released on Decmber 8th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fixed an error in `Cldr.Math.round/3` for `Decimal` numbers where the value being rounded is < 1 but greater than 0 whereby the sign was being returned as `true` instead of `1`.

## Changelog for Cldr Utils version 2.0.2

This is the changelog for Cldr Utils v2.0.2 released on November 23rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Replace *additional* deprecated `Decimal.new/1` with `Decimal.from_float/1` where required

## Changelog for Cldr Utils version 2.0.1

This is the changelog for Cldr Utils v2.0.1 released on November 23rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Replace deprecated `Decimal.new/1` with `Decimal.from_float/1` where required

## Changelog for Cldr Utils version 2.0.0

This is the changelog for Cldr Utils v2.0.0 released on October 29th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Initial release extracted from [ex_cldr](https://hex.pm/packages/ex_cldr)