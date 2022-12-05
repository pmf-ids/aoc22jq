#!/usr/bin/env -S jq -Rnrf

# AoC 2022/05 in jq 1.6

[inputs] | index("") as $p | (false, true) as $cm9001
| reduce (.[$p+1:][] | [scan("\\d+") | tonumber]) as [$n, $from, $to] (
    .[:$p-1] | map([" ", _nwise(4)[1:2]]) | transpose | map(map(select(. != " ")));
    .[$to] = (.[$from][:$n] | select($cm9001) // reverse) + .[$to] | .[$from] |= .[$n:]
  )
| map(first) | add
