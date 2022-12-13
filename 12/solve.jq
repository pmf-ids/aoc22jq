#!/usr/bin/env -S jq -Rnf

# AoC 2022/12 in jq 1.6

[inputs | explode] | (first | length) as $w
| add | [indices(83, 97, 69)] as [[$s], $a, $q]
| {d: 0, m: map(-. % 96 % 82 % 43), $q}

| until(.m[$s] >= 0; {d: (.d + 1), m: (.m[.q[]] = .d).m, q: [.q[] as $q | (
    $q | . - $w, select(. % $w > 0) - 1, select(. % $w < $w - 1) + 1, . + $w
  ) as $n | select(.m | has($n) and .[$n] <= .[$q] + 1) | $n] | unique})

| [.m[$s, $a[]] | select(. >= 0)] | first, min
