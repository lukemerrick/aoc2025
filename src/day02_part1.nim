import std/strformat
import std/strutils
import std/paths
import std/math

const
  Day = 2
  Part = 1
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  InputFile = InputPath / Path(&"day{Day:02}_test.txt")

proc solve(input: string): int =
  var return_val = 0
  let ranges = input.strip().split(',')
  for r in ranges:
    let lo_hi = r.split('-')
    let (lo, hi) = (lo_hi[0].parseInt(), lo_hi[1].parseInt())
    echo fmt"{lo} to {hi}"
    for val in lo..hi:
      var ndigits = 1
      while 10^(ndigits) <= val:
        ndigits += 1
      let divisor = 10^((ndigits) div 2)
      let (left_half, right_half) = divmod(val, divisor)
      if left_half == right_half:
        echo fmt"adding: {val} | divisor: {divisor} | left: {left_half} | right: {right_half}"
        return_val += val
  return return_val

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
