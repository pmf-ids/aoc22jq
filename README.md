# Solving [Advent of Code](https://adventofcode.com/) [2022](https://adventofcode.com/2022/) in [jq](https://stedolan.github.io/jq/) [1.6](https://github.com/stedolan/jq/releases/tag/jq-1.6)

The solutions presented here are written in
jq 1.6, which was released on November 1, 2018. They require
invoking `jq` with some flags (mostly `-R` and `-n`), which are
specified in the example invocations preceding each code section
below, using `solve.jq` and `input.txt` as filenames for the
source code and the input data, respectively. The actual source
code files in this repository, however, also contain a corresponding
shebang prefix, so running them with just `./solve.jq input.txt`
(and execution permissions set) should equally be possible on
most Unix-like operating system.

## [🖿 01](01) solving [Day 1: Calorie Counting](https://adventofcode.com/2022/day/1)
`jq -Rnf solve.jq input.txt`
```jq
[inputs] | [(join(",") / ",,")[] / "," | map(tonumber) | add] | sort[-3:] | last, add
```

## [🖿 02](02) solving [Day 2: Rock Paper Scissors](https://adventofcode.com/2022/day/2)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [explode[0,2] % 4]] | ., map(last = (add + 1) % 3)
| map(last + 1 + (last - first + 5) % 3 * 3) | add
```

## [🖿 03](03) solving [Day 3: Rucksack Reorganization](https://adventofcode.com/2022/day/3)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [(explode[] - 38) % 58]] | map([_nwise(length / 2)]), [_nwise(3)]
| map(until(length < 2; .[:2] |= [first - (first - last)]) | first | first) | add
```

## [🖿 04](04) solving [Day 4: Camp Cleanup](https://adventofcode.com/2022/day/4)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [scan("\\d+") | tonumber]] | ., map([.[0,1,3,2]])
| map(select((.[0] - .[2]) * (.[1] - .[3]) <= 0)) | length
```

## [🖿 05](05) solving [Day 5: Supply Stacks](https://adventofcode.com/2022/day/5)
`jq -Rnrf solve.jq input.txt`
```jq
[inputs] | index("") as $p | (false, true) as $cm9001
| reduce (.[$p+1:][] | [scan("\\d+") | tonumber]) as [$n, $from, $to] (
    .[:$p-1] | map([" ", _nwise(4)[1:2]]) | transpose | map(map(select(. != " ")));
    .[$to] = (.[$from][:$n] | select($cm9001) // reverse) + .[$to] | .[$from] |= .[$n:]
  )
| map(first) | add
```

## [🖿 06](06) solving [Day 6: Tuning Trouble](https://adventofcode.com/2022/day/6)
`jq -Rf solve.jq input.txt`
```jq
. / "" | (4,14) as $n | [while(.[:$n] | any(indices(.[]); .[1]); .[1:])] | $n + length
```

## [🖿 07](07) solving [Day 7: No Space Left On Device](https://adventofcode.com/2022/day/7)
`jq -Rnf solve.jq input.txt`
```jq
reduce (inputs | capture("^(\\$ cd (?<cd>.*)|(?<size>\\d+) (?<file>.*))$"))
  as {$cd, $file, $size} ({};
    if $file then setpath(."" + [$file]; $size | tonumber)
    else ."" |= if $cd == "/" then [] elif $cd == ".." then .[:-1] else . + [$cd] end
    end
  )
| [.. | objects | [.. | numbers] | add] | (max - 40000000) as $th
| (map(select(. <= 100000)) | add), (map(select(. >= $th)) | min)
```

## [🖿 08](08) solving [Day 8: Treetop Tree House](https://adventofcode.com/2022/day/8)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / "" | map(tonumber)] | [., transpose | [., map(reverse) | map(
  reduce to_entries[] as {$key, $value} ([[]];
    first[$value:] as $last | first[$value] = $key
    | .[1][$key] = $last == [] | .[2][$key] = $key - ($last | max // 0)
  ) | .[1:] | transpose
)] | last[] |= reverse] | last[] |= transpose | map(.[] | map(.[])) | transpose

| (map(select(any(first))) | length), (map(reduce .[][1] as $p (1; . * $p)) | max)
```

## [🖿 09](09) solving [Day 9: Rope Bridge](https://adventofcode.com/2022/day/9)
`jq -Rnf solve.jq input.txt`
```jq
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
```

## [🖿 10](10) solving [Day 10: Cathode-Ray Tube](https://adventofcode.com/2022/day/10)
`jq -Rnrf solve.jq input.txt`
```jq
reduce ((inputs / " ")[] | tonumber? // 0) as $p ([1]; . + [last + $p]) | to_entries
| ([(20,60,100,140,180,220) as $p | $p * .[$p - 1].value] | add),
  (map(if .key % 40 - .value | 1 >= fabs then "#" else " " end)[:-1] | _nwise(40) | add)
```

## [🖿 11](11) solving [Day 11: Monkey in the Middle](https://adventofcode.com/2022/day/11)
`jq -Rnf solve.jq input.txt`
```jq
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
```

## [🖿 12](12) solving [Day 12: Hill Climbing Algorithm](https://adventofcode.com/2022/day/12)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | explode] | (first | length) as $w
| add | [indices(83, 97, 69)] as [[$s], $a, $q]
| {d: 0, m: map(-. % 96 % 82 % 43), $q}

| until(.m[$s] >= 0; {d: (.d + 1), m: (.m[.q[]] = .d).m, q: [.q[] as $q | (
    $q | . - $w, select(. % $w > 0) - 1, select(. % $w < $w - 1) + 1, . + $w
  ) as $n | select(.m | has($n) and .[$n] <= .[$q] + 1) | $n] | unique})

| [.m[$s, $a[]] | select(. >= 0)] | first, min
```

## [🖿 13](13) solving [Day 13: Distress Signal](https://adventofcode.com/2022/day/13)
`jq -sf solve.jq input.txt`
```jq
[[[2]], [[6]]] + . | map([tostream | (last | numbers), (first | -1 / (length + 1))])
| ([_nwise(2) | first < last][[true]] | add), ([sort[.[0,1] | [.]][] + 1] | first * last)
```

## [🖿 14](14) solving [Day 14: Regolith Reservoir](https://adventofcode.com/2022/day/14)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / "->" | map(. / "," | map(tonumber))] | ([.[][][1]] | max + 2) as $s
| map(while(has(1); .[1:])[:2] | transpose | map([range(min; max + 1)]))

| reduce ($s, 0) as $p (
    {q: [$s], m: (reduce .[] as [$x, $y] ([]; .[$y[]][$x[] + $s - 500] = 0))};
    until(.q | length == $p; . as {$q, $m} | ($q | length) as $y
      | [$q[-1] + (0, -1, 1) | select($y >= $s or $m[$y][.] | not)] as [$x]
      | if $x then .q += [$x] else .m[$y - 1][$q[-1]] = 1 | .q |= .[:-1] end
    ) | .s += [[.m[] | arrays[]] | add]
  ) | .s[]
```

## [🖿 15](15) solving [Day 15: Beacon Exclusion Zone](https://adventofcode.com/2022/day/15)
`jq -Rnf solve.jq input.txt`
```jq
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
```

## [🖿 16](16) solving [Day 16: Proboscidea Volcanium](https://adventofcode.com/2022/day/16)
`jq -Rnf solve.jq input.txt`
```jq
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
```

## [🖿 18](18) solving [Day 18: Boiling Boulders](https://adventofcode.com/2022/day/18)
`jq -Rsf solve.jq input.txt`
```jq
def pump: map(keys[] as $dim | .[$dim] += (-1,1));

[scan("\\d+") | tonumber] | [.[] - min + 1] | (max + 1) as $box
| [[_nwise(3)] | ., pump, [[0,0,0]]] | [.[1] - (., until(last == []; last = (
    last | pump | [unique[] | select(all(0 <= . and . <= $box))]
  ) - first | first += last) | first)] | first, first - last | length
```

## [🖿 21](21) solving [Day 21: Monkey Math](https://adventofcode.com/2022/day/21)
`jq -Rnf solve.jq input.txt`
```jq
def yell($m):
  .[$m][1:] as [$m1, $op, $m2] | [if $op then yell($m1, $m2) else $m1 | tonumber end]
  | if $op == "/" then first / last elif $op == "*" then first * last
    elif $op == "-" then first - last else add end;

[inputs / " "] | INDEX(first[:-1]) | yell("root") as $root
| .humn = [[$root | . * (-., .)], 0] | .root[2] = "-" | .root[0] = yell("root")
| ([.humn[1] = .humn[0][] | yell("root")] | index(min)) as $side
| until(.root[0] == 0; .humn = [
    (.humn | .[0][1:0] = .[1:])[0][[.root[0] | -., .] | (index(min) + $side) % 2:][:2]
    | ., (add / 2 | rint)
  ] | .root[0] = yell("root"))

| $root, .humn[1]
```

## [🖿 24](24) solving [Day 24: Blizzard Basin](https://adventofcode.com/2022/day/24)
`jq -Rnf solve.jq input.txt`
```jq
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
```

## [🖿 25](25) solving [Day 25: Full of Hot Air](https://adventofcode.com/2022/day/25)
`jq -Rnrf solve.jq input.txt`
```jq
[inputs | reduce drem(-9 * explode[]; 123) as $p (0; . * 5 + $p % 5)] | add
| ["012=-"[[drem(while(. > 1; ./5 | rint) % 5; 5)] | reverse[]:][:1]] | add
```
