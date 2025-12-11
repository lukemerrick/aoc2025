import std/strformat
import std/strutils
import std/paths

const
  Day = 3
  Part = 1
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
    let (left_idx, left_value) = find_leftmost_max(line[0..^2])
    let (right_idx, right_value) = find_leftmost_max(line[left_idx+1..^1])
    result += left_value * 10
    result += right_value

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"