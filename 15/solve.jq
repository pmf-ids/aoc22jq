#!/usr/bin/env -S jq -Rnf

# AoC 2022/15 in jq 1.6

[inputs | [scan("-?\\d+") | tonumber] | . + [[[.[0,2]], [.[1,3]] | max - min] | add]]
| (if any(.[][]; fabs > 25) then 2000000 else 10 end) as $piv | (
  
  map(.[1,3] -= $piv) | (map(select(.[3] == 0)[2]) | unique | length) as $bcn
  | map(last -= (.[1] | fabs) | select(last > 0) | [first - (last, -last)])
  | sort | reduce .[] as [$p,$q] (first | last = 1 - $bcn;
      [fmax(first; $q), fdim($q; fmax($p - 1; first)) + last]
    ) | last
  
), (
  
  map([.[0] - (.[1], -.[1]) - (last, -last)] | [_nwise(2)]) | . as $pqs
  | map((first[] -= 1 | last[] += 1)[]) | transpose
  | map([.[.[unique[] | [.]][1] // []]]) | combinations | . as $cnd
  | select($pqs | all(.[1:1] = [$cnd] | transpose | any(. != sort)))
  | [first *= (1, -1) | add / 2] | select(all(. - $piv | fabs <= $piv))
  | first *= 4000000 | add

)
