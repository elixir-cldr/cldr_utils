# Changelog

## Cldr Utils version 2.19.1

This is the changelog for Cldr Utils v2.19.1 released on August 23rd, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

**Cldr Utils now requires Elixir 1.11 or later**

### Bug Fixes

* Use only TLS 1.2 on OTP versions less than 25.

## Cldr Utils version 2.19.0

This is the changelog for Cldr Utils v2.19.0 released on August 22nd, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

**Cldr Utils now requires Elixir 1.11 or later**

### Enhancements

* Sets SNI option for SSL connections

* Supports `CLDR_UNSAFE_HTTPS` environment variable option which, if set to anything other than `FALSE`, `false`, `nil` or `NIL` will not perform peer verification for HTTPS requests. This may be used in circumstances where peer verification is failing but if generally not recommended.

## Cldr Utils version 2.18.0

This is the changelog for Cldr Utils v2.18.0 released on July 31st, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

**Cldr Utils now requires Elixir 1.11 or later**

### Bug Fixes

* Fix deprecation warnings for Elixir 1.14.

## Cldr Utils version 2.17.2

This is the changelog for Cldr Utils v2.17.2 released on May 8th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Harden the SSL options for `Cldr.Http.get/1` in line with the recommendations at https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/ssl

## Cldr Utils version 2.17.1

This is the changelog for Cldr Utils v2.17.1 released on February 21st, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fix `Cldr.Map.invert/2` to use `Enum.map/2` not `Enum.flat_map/2`

## Cldr Utils version 2.17.0

This is the changelog for Cldr Utils v2.17.0 released on October 27th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `:duplicates` option to `Cldr.Map.invert/2` to determine how to handle duplicate values after inversion. The options are:

  * `nil` or `false` which is the default and means only one value is kept. `Map.new/1` is used meanng the selected value is non-deterministic.
  * `:keep` meaning duplicate values are returned in a list
  * `:shortest` means the shortest duplicate is kept. This operates on string or atom values.
  * `:longest` means the shortest duplicate is kept. This operates on string or atom values.

### Bug Fixes

* Don't attempt to convert calendar era dates to iso days - do that when required in `ex_cldr_calendars`

* Remove `Cldr.Calendar.Conversion` module which is not required

* Fix `Cldr.Map.deep_map/3` so that the `:filter` option is propogated correctly when `:only/:except` is also specified.

## Cldr Utils version 2.17.0-rc.0

This is the changelog for Cldr Utils v2.17.0 released on October 5th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Don't attempt to convert calendar era dates to iso days - do that when required in `ex_cldr_calendars`

* Remove `Cldr.Calendar.Conversion` module which is not required

* Fix `Cldr.Map.deep_map/3` so that the `:filter` option is propogated correctly when `:only/:except` is also specified.

### Enhancements

* Add `:duplicates` option to `Cldr.Map.invert/2` to determine how to handle duplicate values after inversion. The options are:

  * `nil` or `false` which is the default and means only one value is kept. `Map.new/1` is used meanng the selected value is non-deterministic.
  * `:keep` meaning duplicate values are returned in a list
  * `:shortest` means the shortest duplicate is kept. This operates on string or atom values.
  * `:longest` means the shortest duplicate is kept. This operates on string or atom values.

## Cldr Utils version 2.16.0

This is the changelog for Cldr Utils v2.16.0 released on June 11th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Map.extract_strings/2`

* Make resolver a parameter to `Cldr.Map.deep_merge/3`

* Make resolver a parameter to `Cldr.Map.merge_map_list/2`

* Add `Cldr.Map.prune/2` that prunes (deletes) branches from a (possibly deeply nested) map

* Add `Cldr.Map.invert/1` that inverts the `{key, value}` of a map to be `{value, key}` and if `value` is a list, one new map entry for each element of `value` will be created (mapped to `key`)

## Cldr Utils version 2.15.1

This is the changelog for Cldr Utils v2.15.1 released on March 16th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fix `Cldr.Digit.to_number/2` for floats. Thanks for the report from @jlauemoeller. Fixes #15.

## Cldr Utils version 2.15.0

This is the changelog for Cldr Utils v2.15.0 released on March 5th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Adds the options `:filter`, `:reject` and `:skip` to `Cldr.Map.deep_map/3` that work on entire branches of a map.

## Cldr Utils version 2.14.1

This is the changelog for Cldr Utils v2.14.1 released on February 17th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Merge the fixes from cldr_utils version 2.13.3 for `Cldr.Math.power/2`

## Cldr Utils version 2.14.0

This is the changelog for Cldr Utils v2.14.0 released on November 7th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Adds `Cldr.Http.get/1` to download from `https` URLs using `:httpc` but with certificate vertification enabled (it is not enabled by default in the `:httpc` module).

## Cldr Utils version 2.13.3

This is the changelog for Cldr Utils v2.13.3 released on February 17th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug fixes

* Fix `Cldr.Math.power/2` when both arguments are Decimal and the power is negative.

* Update the docs for `Cldr.Math.round_significant/2` to note that rounding floats to significant digits cannot always return the expected precision since floats cannot represent all decimal numbers correctly.

## Cldr Utils version 2.13.2

This is the changelog for Cldr Utils v2.13.2 released on October 20th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug fixes

* Fix unused variable warning on OTP versions that do not include `:persistent_term` module. Thanks to @kianmeng.

## Cldr Utils version 2.13.1

This is the changelog for Cldr Utils v2.13.1 released on September 30th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Decimal.parse/1` as a compatibiity layer for Decimal 1.x and 2.x

## Cldr Utils version 2.12.0

This is the changelog for Cldr Utils v2.12.0 released on September 29th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Digit.number_of_trailing_zeros/1` to calculate the number of trailing zeros in an integer

## Cldr Utils version 2.11.0

This is the changelog for Cldr Utils v2.11.0 released on September 25th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Provides `Cldr.Decimal.reduce/1` as a compatibility shim for Decimal 1.x and 2.x

* Provides `Cldr.Decimal.compare/2` as a compatibility shim for Decimal 1.x and 2.x

## Cldr Utils version 2.10.0

This is the changelog for Cldr Utils v2.10.0 released on September 8th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Supports `Decimal` 1.6 or greater or `Decimal` 2.x or later

## Cldr Utils version 2.9.1

This is the changelog for Cldr Utils v2.9.1 released on May 3rd, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fix compatibility with `ex_cldr` releases up to 2.13.0.  Thanks to @hl for the report. Fixes #3.

## Cldr Utils version 2.9.0

This is the changelog for Cldr Utils v2.9.0 released on May 2nd, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `:level`, `:only` and `:except` options to `Cldr.Map.deep_map/3` and refactor functions that use it

* Add `Cldr.Enum.reduce_peeking/3` that is a simple reduce function that also passed the tail of the enum being reduced to enable a simple form of lookahead

* Refactor `Cldr.Math.round/2` implementation for floating point numbers that improves efficiency by about 100% since it avoids round trip conversion to `Decimal`

## Cldr Utils version 2.8.0

This is the changelog for Cldr Utils v2.8.0 released on February 14th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Be more resilient of the availability of `:persistent_term` given that `get/2`, `get/1` and `:persistent_term` itself are available on different OTP releases. Thanks to @halostatue. Closes #2.

## Cldr Utils version 2.7.0

This is the changelog for Cldr Utils v2.7.0 released on January 31st, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.String.to_underscore/1` that replaces "-" with "_"

## Cldr Utils version 2.6.0

This is the changelog for Cldr Utils v2.6.0 released on January 21st, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Support `Decimal` versions `~> 1.6 or 1.9 or 2.0`.  Version 1.9 deprecates `Decimal.compare/2` in favour of `Decimal.cmp/2`. The upcoming `Decimal` version 2.0 deprecates `Decimal.cmp/2` in favour of a new implementation of `Decimal.compare/2` that conforms to Elixir norms and is required to support `Enum.sort/2` correctly.  This version of `cldr_utils` detects the relevant version and adapts accordingly at compile time.

## Cldr Utils version 2.5.0

This is the changelog for Cldr Utils v2.5.0 released on October 22nd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Macros.warn_once/3` to log a warning, but only once for a given key

## Cldr Utils version 2.4.0

This is the changelog for Cldr Utils v2.4.0 released on August 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.String.hash/1` to implement a polynomial rolling hash function

## Cldr Utils version 2.3.0

This is the changelog for Cldr Utils v2.3.0 released on June 15th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Adds `doc_since/1` and `calendar_impl/0` to support conditional compilation based upon Elixir versions

## Cldr Utils version 2.2.0

This is the changelog for Cldr Utils v2.2.0 released on March 25th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Add `Cldr.Math.div_amod/2`

## Cldr Utils version 2.1.0

This is the changelog for Cldr Utils v2.1.0 released on March 10th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* `Cldr.Map.integerize_keys/1` now properly processes negative integer keys. Minor version change to make it easier to peg versions in upstream packages.

## Cldr Utils version 2.0.5

This is the changelog for Cldr Utils v2.0.4 released on Jnauary 3rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fixes `Cldr.Math.round/3` for floats when rounding is > 0 digits

## Cldr Utils version 2.0.4

This is the changelog for Cldr Utils v2.0.4 released on Decmber 15th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fixes `Cldr.Math.round/3` to be compatible with `Decimal.round/3` and `Kernel.round/1`

## Cldr Utils version 2.0.3

This is the changelog for Cldr Utils v2.0.3 released on Decmber 8th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Bug Fixes

* Fixed an error in `Cldr.Math.round/3` for `Decimal` numbers where the value being rounded is < 1 but greater than 0 whereby the sign was being returned as `true` instead of `1`.

## Cldr Utils version 2.0.2

This is the changelog for Cldr Utils v2.0.2 released on November 23rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Replace *additional* deprecated `Decimal.new/1` with `Decimal.from_float/1` where required

## Cldr Utils version 2.0.1

This is the changelog for Cldr Utils v2.0.1 released on November 23rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Replace deprecated `Decimal.new/1` with `Decimal.from_float/1` where required

## Cldr Utils version 2.0.0

This is the changelog for Cldr Utils v2.0.0 released on October 29th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_utils/tags)

### Enhancements

* Initial release extracted from [ex_cldr](https://hex.pm/packages/ex_cldr)
