import std/strformat
import std/strutils
import std/paths
import std/math

const
  Day = 3
  Part = 2
  NumBatteries = 12
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

func parseInt(c: char): int =
  return int(c) - int('0')

func parse_input(input: string): seq[seq[int]] =
  let lines = input.strip().splitLines()
  for i, line in pairs(lines):
    var line_data: seq[int]
    for j, c in pairs(line):
      line_data.add(c.parseInt())
    result.add(line_data)

func find_leftmost_max(line: seq[int]): (int, int) =
  for i, c in pairs(line):
    if c > result[1]:
      result = (i, c)

func solve(input: string): int =
  result = 0
  let data = parse_input(input)
  for line in data:
    var start_idx = 0
    for battery_value in countdown(NumBatteries, 1):
      let (idx, val) = find_leftmost_max(line[start_idx..^battery_value])
      start_idx += idx + 1
      result += val * 10^(battery_value - 1)

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"