import std/strformat
import std/strutils
import std/paths
import std/sequtils

const
  Day = 7
  Part = 1
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  # InputFile = InputPath / Path(&"day{Day:02}_test.txt")
  InputFile = InputPath / Path(&"day{Day:02}.txt")


proc active_string(active: seq[bool]): string =
  result = ""
  for x in active:
    result &= (if x: "|" else: ".")

proc solve(input: string): int =
  let lines = input.strip(leading=false, chars={'\n'}).splitLines()
  let width = lines[0].len
  var active = newSeq[bool](width)
  var nextActive = newSeq[bool](width)
  for i in 0..<width:
    active[i] = false
    nextActive[i] = false
  for i, c in pairs(lines[0]):
    if c == 'S':
      active[i] = true
  for line in lines[1..^1]:
    for i, c in pairs(line):
      if active[i]:
        case c:
          of '.':
            nextActive[i] = true
          of '^':
            result += 1
            let a = i - 1
            let b = i + 1
            if a >= 0:
              nextActive[a] = true
            if b < width:
              nextActive[b] = true
          else:
            raise newException(ValueError, fmt"unrecognized character: {c}")
    # echo fmt"active_string:     {active_string(active)}"
    # echo fmt"line:              {line}"
    # echo fmt"nextActive_string: {active_string(nextActive)}"
    # echo ""
    for i in 0..<width:
      active[i] = nextActive[i]
      nextActive[i] = false
  

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
