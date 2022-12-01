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
