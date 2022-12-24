#!/usr/bin/env -S jq -Rnf

# AoC 2022/24 in jq 1.6

[inputs / ""] | [["<", ">", .], ["^", "v", transpose] | . as [$back, $forth] | last | [
  (first[1:-1] | keys)[] as $min | [null, (.[1:-1][] | [null, (.[1:-1] | keys[] as $pos
    | .[($pos + $min) % length] != $back and .[($pos - $min + length) % length] != $forth
  )])]
]] as $winds | [$winds[] | length] as $cycles

| [foreach ([[1] + first[["."]], $cycles[1:] + last[["."]]] | ., reverse, .)
    as [$from, $to] ({}; .pos = [] | until(.pos | bsearch($to) >= 0; .min += 1
      | [(0,1) as $axis | $winds[$axis][.min % $cycles[$axis]]] as $wind
      | .pos += [(.pos[] | first = first + (-1,1), last = last + (-1,1)), $from]
      | .pos |= [unique[] | select($wind[0][first][last] and $wind[1][last][first])]
    ); .min + 1)
  ] | first, last
