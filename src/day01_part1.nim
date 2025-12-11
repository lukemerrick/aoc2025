import std/strformat
import std/strutils
import std/paths
import std/math

const
  Day = 1
  Part = 1
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

func solve(input: string): int =
  result = 0
  var position = 50
  for line in input.strip().splitLines():
    let direction = (if line[0] == 'R': 1 else: -1)
    let distance = line[1..^1].parseInt()
    let value = direction * distance
    position = (100 + position + value) mod 100
    if position == 0:
      result += 1

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
