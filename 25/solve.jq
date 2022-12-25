#!/usr/bin/env -S jq -Rnrf

# AoC 2022/25 in jq 1.6

[inputs | reduce drem(-9 * explode[]; 123) as $p (0; . * 5 + $p % 5)] | add
| ["012=-"[[drem(while(. > 1; ./5 | rint) % 5; 5)] | reverse[]:][:1]] | add
