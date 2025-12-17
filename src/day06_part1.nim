import std/strformat
import std/strutils
import std/paths
import std/re

const
  Day = 6
  Part = 1
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  # InputFile = InputPath / Path(&"day{Day:02}_test.txt")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

type
  ProblemNumbers = seq[int]
  Operation = enum 
    Add = "+", 
    Multiply = "*",
  ParseResult = tuple[problem_numbers: seq[ProblemNumbers], operations: seq[Operation]]

proc parse_input(input: string): ParseResult =
  let OneOrMoreWhitespace = re"\s+"
  let lines = input.strip().splitLines()
  let first_line_pieces = lines[0].strip().split(OneOrMoreWhitespace)
  let num_problems = len(first_line_pieces)
  result.problem_numbers = newSeq[ProblemNumbers](num_problems)
  result.operations = newSeq[Operation](num_problems)
  for line in lines[0..^2]:
    for i, number_str in pairs(line.strip().split(OneOrMoreWhitespace)):
      result.problem_numbers[i].add(number_str.parseInt())
  for i, op_str in pairs(lines[^1].strip().split(OneOrMoreWhitespace)):
    let op = parseEnum[Operation](op_str)
    result.operations[i] = op

proc solve(input: string): int =
  # Initialize the result.
  result = 0

  # Parse the string input.
  let (numbers, operations) = parse_input(input)
  assert numbers.len == operations.len

  # Do the calculations.
  for i in 0..<numbers.len:
    let problem_values = numbers[i]
    let operation = operations[i]
    case operation:
      of Add:
        for value in problem_values:
          result += value
      of Multiply:
        var product = 1
        for value in problem_values:
          product *= value
        result += product

  

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
