#!/usr/bin/env -S jq -sf

# AoC 2022/13 in jq 1.6

[[[2]], [[6]]] + . | map([tostream | (last | numbers), (first | -1 / (length + 1))])
| ([_nwise(2) | first < last][[true]] | add), ([sort[.[0,1] | [.]][] + 1] | first * last)
