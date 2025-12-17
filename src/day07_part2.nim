import std/strformat
import std/strutils
import std/paths
import std/sequtils

const
  Day = 7
  Part = 2
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  # InputFile = InputPath / Path(&"day{Day:02}_test.txt")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

proc paths_string(paths: seq[int]): string =
  result = ""
  for x in paths:
    result &= fmt" {x:02} "

proc expanded_line(line: string): string =
  result = ""
  for x in line:
    result &= "  " & $x & " "

proc solve(input: string): int =
  let lines = input.strip(leading=false, chars={'\n'}).splitLines()
  let width = lines[0].len
  var paths_below = newSeq[int](width)
  var next_paths_below = newSeq[int](width)
  for i in 0..<width:
    paths_below[i] = 1
    next_paths_below[i] = 0
  for i in countdown(lines.len - 1, 0):
    let line = lines[i]
    for j, c in pairs(line):
      case c:
        of '.':
          next_paths_below[j] = paths_below[j]
        of '^':
          let a = j - 1
          let b = j + 1
          if a >= 0:
            next_paths_below[j] += paths_below[a]
          if b < width:
            next_paths_below[j] += paths_below[b]
        of 'S':
          result = paths_below[j]
        else:
          raise newException(ValueError, fmt"unrecognized character: {c}")

    # echo fmt"next_paths_below: {paths_string(next_paths_below)}"
    # echo fmt"line:             {expanded_line(line)}"
    # echo fmt"paths_below:      {paths_string(paths_below)}"
    # echo ""

    for j in 0..<width:
      paths_below[j] = next_paths_below[j]
      next_paths_below[j] = 0
  

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
