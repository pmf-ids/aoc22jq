#!/usr/bin/env -S jq -Rnf

# AoC 2022/14 in jq 1.6

[inputs / "->" | map(. / "," | map(tonumber))] | ([.[][][1]] | max + 2) as $s
| map(while(has(1); .[1:])[:2] | transpose | map([range(min; max + 1)]))

| reduce ($s, 0) as $p (
    {q: [$s], m: (reduce .[] as [$x, $y] ([]; .[$y[]][$x[] + $s - 500] = 0))};
    until(.q | length == $p; . as {$q, $m} | ($q | length) as $y
      | [$q[-1] + (0, -1, 1) | select($y >= $s or $m[$y][.] | not)] as [$x]
      | if $x then .q += [$x] else .m[$y - 1][$q[-1]] = 1 | .q |= .[:-1] end
    ) | .s += [[.m[] | arrays[]] | add]
  ) | .s[]
