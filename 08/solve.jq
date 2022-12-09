#!/usr/bin/env -S jq -Rnf

# AoC 2022/08 in jq 1.6

[inputs / "" | map(tonumber)] | [., transpose | [., map(reverse) | map(
  reduce to_entries[] as {$key, $value} ([[]];
    first[$value:] as $last | first[$value] = $key
    | .[1][$key] = $last == [] | .[2][$key] = $key - ($last | max // 0)
  ) | .[1:] | transpose
)] | last[] |= reverse] | last[] |= transpose | map(.[] | map(.[])) | transpose

| (map(select(any(first))) | length), (map(reduce .[][1] as $p (1; . * $p)) | max)
