#!/usr/bin/env -S jq -Rnf

# AoC 2022/04 in jq 1.6

[inputs | [scan("\\d+") | tonumber]] | ., map([.[0,1,3,2]])
| map(select((.[0] - .[2]) * (.[1] - .[3]) <= 0)) | length
