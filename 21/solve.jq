#!/usr/bin/env -S jq -Rnf

# AoC 2022/21 in jq 1.6

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
