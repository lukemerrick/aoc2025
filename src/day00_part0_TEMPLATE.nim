import std/strformat
import std/strutils
import std/paths

const
  Day = 0
  Part = 1
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

func solve(input: string): int =
  ## Simple example: sum all integers, one per line.
  result = 0
  for line in input.splitLines():
    let trimmed = line.strip()
    if trimmed.len == 0: continue
    result += parseInt(trimmed)
  return result

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
