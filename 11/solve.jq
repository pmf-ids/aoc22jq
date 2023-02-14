#!/usr/bin/env -S jq -Rnf

# AoC 2022/11 in jq 1.6

[inputs]
| reduce (_nwise(7) | map([scan("\\+|\\*"), (scan("\\d+|true|false") | fromjson)]))
  as [[$mid], $list, [$iop, $val], [$div], [$b1, $m1], [$b2, $m2]] ([];
    .[$mid] = {$mid, $list, $iop, $val, $div, ("\($b1)"): $m1, ("\($b2)"): $m2}
  )
 
| ([20, "/", 3], [10000, "%", reduce .[].div as $div (1; . * $div)]) as [$dur, $rop, $rel]
| nth($dur; recurse(reduce .[].mid as $m (.;
    reduce .[$m].list[] as $old (.[$m] |= (.act += (.list | length) | .list = []); (.[$m]
      | if .iop == "*" then $old * (.val // $old) else $old + (.val // $old) end
      | if $rop == "/" then . / $rel | floor else . % $rel end
    ) as $new | .[.[$m] | .["\($new % .div == 0)"]].list += [$new])
  )))

| map(.act) | sort | .[-1] * .[-2]
