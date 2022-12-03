#!/usr/bin/env -S jq -Rnf

# AoC 2022/03 in jq 1.6

[inputs | [(explode[] - 38) % 58]] | map([_nwise(length / 2)]), [_nwise(3)]
| map(until(length < 2; .[:2] |= [first - (first - last)]) | first | first) | add
