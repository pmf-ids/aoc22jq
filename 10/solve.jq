#!/usr/bin/env -S jq -Rnrf

# AoC 2022/10 in jq 1.6

reduce ((inputs / " ")[] | tonumber? // 0) as $p ([1]; . + [last + $p]) | to_entries
| ([(20,60,100,140,180,220) as $p | $p * .[$p - 1].value] | add),
  (map(if .key % 40 - .value | 1 >= fabs then "#" else " " end)[:-1] | _nwise(40) | add)
