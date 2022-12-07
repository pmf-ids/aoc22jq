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
