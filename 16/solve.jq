#!/usr/bin/env -S jq -Rnf

# AoC 2022/16 in jq 1.6

[inputs | [scan("[A-Z]{2}|\\d+")]] | [sort_by(.[1] == "0", .)[][0]] as $v
| map(map(tonumber? // $v[[.]][])) | sort | map(.[1:] = (.[2:][] | [.])) as $e

| [.[][1]] as $w | reduce $e[] as $h (.[] = map(null); setpath($h; 2))
| map(until(all; reduce $e[] as [$i,$j] (.; .[$j] //= (.[$i] | (values+1) // null)))) as $g
| $w[[0]][0] | [., exp2-1] as [$a,$b]

| foreach ([$a,$b] + ([0,30], [1,26])) as $c ([[]]; . + [$c] | until(length == 1;
    if getpath([0] + last) then .[:-1] else
      [last | (select(.[2] > 0) | [$a, .[1], .[2]-1, $c[-1]]), (
        select(all(.[1,3]; . > 0))
        | (.[1] | [recurse(. / 2 | floor; 0 < .) % 2][[1]][]) as $m
        | (.[3] - $g[.[0]][$m] | select(. >= 0)) as $t
        | [$m, .[1] - ($m | exp2), .[2], $t]
      )] as $p | [getpath([0] + $p[])] as $q
      | if $q | all then setpath([0] + last; last | $w[.[0]] * .[3] + ($q | max))[:-1]
        else . + [$p[$q[[null]][]]] end
    end
  ); .[] | getpath($c))
