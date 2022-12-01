#!/usr/bin/env -S jq -Rnf

# AoC 2022/01 in jq 1.6

[inputs] | [(join(",") / ",,")[] / "," | map(tonumber) | add] | sort[-3:] | last, add
