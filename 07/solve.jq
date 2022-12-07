#!/usr/bin/env -S jq -Rnf

# AoC 2022/07 in jq 1.6

reduce (inputs | capture("^(\\$ cd (?<cd>.*)|(?<size>\\d+) (?<file>.*))$"))
  as {$cd, $file, $size} ({};
    if $file then setpath(."" + [$file]; $size | tonumber)
    else ."" |= if $cd == "/" then [] elif $cd == ".." then .[:-1] else . + [$cd] end
    end
  )
| [.. | objects | [.. | numbers] | add] | (max - 40000000) as $th
| (map(select(. <= 100000)) | add), (map(select(. >= $th)) | min)
