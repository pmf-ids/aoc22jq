#!/usr/bin/env -S jq -Rnf

# AoC 2022/02 in jq 1.6

[inputs | [explode[0,2] % 4]] | ., map(last = (add + 1) % 3)
| map(last + 1 + (last - first + 5) % 3 * 3) | add
