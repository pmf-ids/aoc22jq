#!/usr/bin/env -S jq -Rf

# AoC 2022/06 in jq 1.6

. / "" | (4,14) as $n | [while(.[:$n] | any(indices(.[]); .[1]); .[1:])] | $n + length
