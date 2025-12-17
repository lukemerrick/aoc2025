import std/strformat
import std/strutils
import std/paths
import std/sequtils

const
  Day = 6
  Part = 2
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  # InputFile = InputPath / Path(&"day{Day:02}_test.txt")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

type
  Mode = enum
    Add = "+",
    Multiply = "*",
    Unset = "",

proc parse_input(input: string): seq[seq[char]]=
  let lines = input.strip(leading=false, chars={'\n'}).splitLines()
  let num_lines = lines.len
  let num_cols = len(lines[0])
  for i in 0..<num_lines:
    assert len(lines[i]) == num_cols

  # Initialize the result.
  result = newSeq[seq[char]](num_lines)
  for i in 0..<num_lines:
    result[i] = newSeq[char](num_cols)

  # Populate.
  for i, line in pairs(lines):
    for j, c in pairs(line):
      result[i][j] = c

func parseInt(c: char): int =
  return int(c) - int('0')

func is_digit(c: char): bool =
  return int(c) >= int('0') and int(c) <= int('9')

proc print_grid(grid: seq[seq[char]]) =
  for row in grid:
    echo row.map(proc (c: char): string = $c).join(" ")

proc solve(input: string): int =
  # Initialize the result.
  result = 0

  # Parse the string input.
  let grid = parse_input(input)
  print_grid(grid)

  var mode = Mode.Unset
  var problem_result = 0

  # Go column by column.
  for j in 0..<grid[0].len:

    # Get the current number top-to-bottom.
    var current_number = 0
    for i in 0..(grid.len - 2):
      let c = grid[i][j]
      if is_digit(c):
        current_number = current_number * 10 + parseInt(c)
    echo fmt"current_number: {current_number}"

    # Parse the operation for the group.
    let op_char = grid[grid.len - 1][j]
    var is_new_problem = false
    case op_char:
      of '+':
        mode = Mode.Add
        is_new_problem = true
      of '*':
        mode = Mode.Multiply
        is_new_problem = true
      else:
        discard

    # Apply current result when we hit the next problem.
    if is_new_problem:
      echo fmt"adding problem_result: {problem_result}"
      result += problem_result
      problem_result = case mode:
        of Mode.Add: 0
        of Mode.Multiply: 1
        else: raise newException(ValueError, "unreachable")

      case mode:
        of Mode.Add:
          problem_result = 0
        of Mode.Multiply:
          problem_result = 1
        else:
          discard

      
    # Apply the current number to the problem result.
    if current_number != 0:
      case mode:
        of Mode.Add:
          problem_result += current_number
        of Mode.Multiply:
          problem_result *= current_number
        else:
          raise newException(ValueError, "unreachable")

  # Add the final problem result.
  echo fmt"adding final problem_result: {problem_result}"
  result += problem_result

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
