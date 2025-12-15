import std/strformat
import std/strutils
import std/paths
import std/algorithm

const
  Day = 5
  Part = 2
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  # InputFile = InputPath / Path(&"day{Day:02}_test.txt")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

type
  IdRange = tuple[lo: int, hi: int]
  ParseResult = tuple[fresh_slices: seq[IdRange], ids: seq[int]]

func parse_input(input: string): ParseResult =
  let lines = input.strip().splitLines()
  var is_section_one = true
  for line in lines:
    if line == "":
      is_section_one = false
      continue
    if is_section_one:
      let pieces = line.split('-')
      assert pieces.len == 2
      let slice = (pieces[0].parseInt(), pieces[1].parseInt())
      result.fresh_slices.add(slice)
    else:
      let id = line.parseInt()
      result.ids.add(id)

func build_sorted_boundaries(slices: seq[IdRange]): seq[int] =
  let sorted_slices = slices.sorted()
  var current_end: int
  var is_currently_fresh = false

  # Start a fresh streak using the first slice.
  let (first_lo, first_hi) = sorted_slices[0]
  result.add(first_lo)
  current_end = first_hi

  # Iterate over the sorted slices, resolving streaks as needed.
  for (lo, hi) in sorted_slices[1..^1]:
    if lo <= current_end:  # Continuing a fresh streak.
      current_end = max(current_end, hi)
    else:  # Ending a fresh streak and starting a new one.
      result.add(current_end)
      result.add(lo)
      current_end = hi
  result.add(current_end)  # End the final pending fresh streak at the end.

proc solve(input: string): int =
  # Parse the string input.
  let (raw_fresh_slices, numbers) = parse_input(input)

  # Get sorted non-overlapping fresh slices.
  let boundary_ids = build_sorted_boundaries(raw_fresh_slices)

  # Count the of items per range from the boundary ids.
  for i in countup(0, boundary_ids.len - 1, 2):
    result += boundary_ids[i + 1] - boundary_ids[i] + 1
  

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
