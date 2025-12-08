# Advent of Code 2025 – Nim Workspace

This is a minimal Nim project for solving Advent of Code 2025.  
Each solution is a small standalone script in `src/`, and puzzle inputs are stored in the `inputs/` directory.

## Compiling and running a solution

From the project root:

``` shell
# Compile and run in one shot.
nim r src/day01_part1.nim
```

## Layout
- `aoc2025.nimble` – basic Nimble project file.
- `src/` – solution scripts, e.g. `day01_part1.nim`.
- `src/day00_part1_TEMPLATE.nim` - starting template that handles input parsing
- `inputs/` – downloaded puzzle inputs

## Input conventions

I download the Advent of Code input for each day and save it as:

- `inputs/day01.txt`
- `inputs/day02.txt`

This makes the template work nicely.
