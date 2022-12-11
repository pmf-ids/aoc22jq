#!/usr/bin/env -S jq -Rnf

# AoC 2022/09 in jq 1.6

[inputs / " " | map(tonumber? // (explode[] | .%19, drem(.-2; 7) | .%2))] | [2,10] as $kn
| reduce .[] as [$axis, $step, $dist] ([[range($kn | max) | [0,0]], ($kn | map({}))];
    reduce range($dist) as $_ (.;
      first |= ([(first | .[$axis] += $step), .[1:]] | until(last == [];
        (.[-2:] | last |= first | transpose) as $comp | .[-1:] |= map(
          if $comp | any(first - last | fabs > 1)
          then ($comp | map(first - ((first - last) / 2 | rint))), .[1:]
          else .[], [] end
        ))[:-1])
      | reduce ($kn | keys[]) as $k (.; last[$k][first[$kn[$k] - 1] | @text] = 1)
    )
  )
| last[] | length
