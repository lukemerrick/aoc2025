import std/strformat
import std/strutils
import std/paths

const
  Day = 4
  Part = 2
  AdjacentLimit = 3
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

func parse_input(input: string): seq[seq[bool]] =
  let lines = input.strip().splitLines()
  for line in lines:
    var line_data: seq[bool]
    for c in line:
      line_data.add(c == '@')
    result.add(line_data)


func remove_rolls(data: seq[seq[bool]]): (int, seq[seq[bool]]) =
  var num_removed = 0
  var after_removed = newSeq[seq[bool]](data.len)
  for i in 0..<data.len:
    let lo_row = max(0, i - 1)
    let hi_row = min(data.len - 1, i + 1)
    after_removed[i] = newSeq[bool](data[i].len)
    for j in 0..<data[i].len:
      after_removed[i][j] = data[i][j]
      if not data[i][j]:
        continue
      var num_adjacent = 0
      let lo_col = max(0, j - 1)
      let hi_col = min(data[i].len - 1, j + 1)
      for row in lo_row..hi_row:
        for col in lo_col..hi_col:
          if row == i and col == j:
            continue
          num_adjacent += data[row][col].ord
      if num_adjacent <= AdjacentLimit:
        num_removed += 1
        after_removed[i][j] = false
  return (num_removed, after_removed)


proc solve(input: string, verbose: bool = false): int =
  var data = parse_input(input)
  while true:
    let (num_removed, after_removed) = remove_rolls(data)
    data = after_removed
    result += num_removed
    if num_removed == 0:
      break

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data, verbose = false)
  echo fmt"Day {Day} Part {Part}: {answer}"
