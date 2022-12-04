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
