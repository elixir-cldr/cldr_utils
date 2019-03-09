## Changelog for Cldr Utils version 2.0.6

This is the changelog for Cldr Utils v2.0.6 released on March 10th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Bug Fixes

* `Cldr.Map.integerize_keys/1` now properly processes negative integer keys

## Changelog for Cldr Utils version 2.0.5

This is the changelog for Cldr Utils v2.0.4 released on Jnauary 3rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Bug Fixes

* Fixes `Cldr.Math.round/3` for floats when rounding is > 0 digits

## Changelog for Cldr Utils version 2.0.4

This is the changelog for Cldr Utils v2.0.4 released on Decmber 15th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Bug Fixes

* Fixes `Cldr.Math.round/3` to be compatible with `Decimal.round/3` and `Kernel.round/1`

## Changelog for Cldr Utils version 2.0.3

This is the changelog for Cldr Utils v2.0.3 released on Decmber 8th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Bug Fixes

* Fixed an error in `Cldr.Math.round/3` for `Decimal` numbers where the value being rounded is < 1 but greater than 0 whereby the sign was being returned as `true` instead of `1`.

## Changelog for Cldr Utils version 2.0.2

This is the changelog for Cldr Utils v2.0.2 released on November 23rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Enhancements

* Replace *additional* deprecated `Decimal.new/1` with `Decimal.from_float/1` where required

## Changelog for Cldr Utils version 2.0.1

This is the changelog for Cldr Utils v2.0.1 released on November 23rd, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Enhancements

* Replace deprecated `Decimal.new/1` with `Decimal.from_float/1` where required

## Changelog for Cldr Utils version 2.0.0

This is the changelog for Cldr Utils v2.0.0 released on October 29th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/kipcole9/cldr_utils/tags)

### Enhancements

* Initial release extracted from [ex_cldr](https://hex.pm/packages/ex_cldr)