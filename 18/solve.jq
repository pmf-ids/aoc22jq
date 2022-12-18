#!/usr/bin/env -S jq -Rsf

# AoC 2022/18 in jq 1.6

def pump: map(keys[] as $dim | .[$dim] += (-1,1));

[scan("\\d+") | tonumber] | [.[] - min + 1] | (max + 1) as $box
| [[_nwise(3)] | ., pump, [[0,0,0]]] | [.[1] - (., until(last == []; last = (
    last | pump | [unique[] | select(all(0 <= . and . <= $box))]
  ) - first | first += last) | first)] | first, first - last | length
