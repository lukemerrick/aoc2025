import std/strformat
import std/strutils
import std/paths
import std/math
import std/sequtils

const
  Day = 2
  Part = 2
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

proc solve(input: string): int =
  var return_val = 0
  let ranges = input.strip().split(',')
  for r in ranges:
    let lo_hi = r.split('-')
    let (lo, hi) = (lo_hi[0].parseInt(), lo_hi[1].parseInt())
    echo fmt"{lo} to {hi}"
    var ndigits = 1
    for val in lo..hi:
      # Increment the number of digits if needed.
      while 10^(ndigits) <= val:
        ndigits += 1

      # Check each chunksize against this value.
      for chunksize in 1..(ndigits div 2):
        # Skip non-evenly-divisible chunksizes.
        let (num_chunks, remainder) = divmod(ndigits, chunksize)
        if remainder != 0:
          continue

        # Split the value into chunks, breaking early on non-matching.
        var prev_item = -1
        var all_equal = true
        for i in 0..<num_chunks:
          let shifted = val div 10^(chunksize * i)
          let item_i = shifted mod 10^chunksize
          if prev_item == -1:
            prev_item = item_i
          else:
            if item_i != prev_item:
              all_equal = false
              break

        if all_equal:
          # echo fmt"adding: {val} | chunksize: {chunksize} | items: {items}"
          return_val += val
          break  # Important: No double-counting the same value!
  return return_val

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
