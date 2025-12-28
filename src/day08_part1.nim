import std/strformat
import std/strutils
import std/paths
import std/sequtils
import std/math
import std/algorithm
import std/tables
import std/sets
import std/hashes

const
  NumConnections = 1000
  NumLargestCircuits = 3
  Day = 8
  Part = 1
  InputPath = Path(instantiationInfo(-1).filename).splitFile().dir / Path("inputs")
  # InputFile = InputPath / Path(&"day{Day:02}_test.txt")
  InputFile = InputPath / Path(&"day{Day:02}.txt")

type
  Coordinate = tuple[x: int, y: int, z: int]
  Connection = tuple[first_index: int, second_index: int, distance: float]
  Circuit = ref object
    node_indices: seq[int]

proc `$`(c: Circuit): string =
  if c == nil:
    return "Circuit(nil)"
  return fmt"Circuit[nodes: {c.node_indices}]"

func hash(c: Circuit): Hash =
  if c == nil:
    return 0.Hash
  # Hash by pointer identity (reference identity)
  result = cast[Hash](cast[pointer](c))

proc parse_input(input: string): seq[Coordinate]=
  let lines = input.strip(leading=false, chars={'\n'}).splitLines()
  result = newSeq[Coordinate](lines.len)
  for i, line in pairs(lines):
    let pieces = line.split(',')
    assert pieces.len == 3
    result[i] = (x: pieces[0].parseInt, y: pieces[1].parseInt, z: pieces[2].parseInt)

func distance(a: Coordinate, b: Coordinate): float =
  return ((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2).toFloat.sqrt

proc insert_and_shift[T](seq: var seq[T], index: int, value: T) =
  for i in countdown(seq.len - 1, index + 1):
    seq[i] = seq[i - 1]
  seq[index] = value

proc find_connections(coordinates: seq[Coordinate], num_connections: int): seq[Connection] =
  var best_distances = newSeqWith(num_connections, float.high)
  result = newSeqWith(num_connections, (first_index: -1, second_index: -1, distance: float.high))
  for i, coordinate in pairs(coordinates):
    for j in i+1..<coordinates.len:
      let other = coordinates[j]
      let distance = distance(coordinate, other)
      if distance < best_distances[^1]:
        let insert_index = best_distances.upperBound(distance)
        assert insert_index < num_connections
        best_distances.insert_and_shift(insert_index, distance)
        result.insert_and_shift(insert_index, (first_index: i, second_index: j, distance: distance))


proc find_circuits(connections: seq[Connection]): seq[Circuit] =
  # Process each connection, building up a map from coordinate index to the circuit 
  # that coordinate belongs to.
  var circuits = newTable[int, Circuit]()
  for connection in connections:
    let first_index = connection.first_index
    let second_index = connection.second_index
    # echo fmt"processing connection {first_index} <-> {second_index}"

    # Neither index is in a circuit, create a new circuit with both.
    if first_index notin circuits and second_index notin circuits:
      # echo fmt"creating new circuit for {first_index} and {second_index}"
      let circuit = Circuit(node_indices: @[first_index, second_index])
      circuits[first_index] = circuit
      circuits[second_index] = circuit

    # Only one index is in a circuit, add the other index to the existing circuit.
    elif first_index notin circuits and second_index in circuits:
      # echo fmt"adding {first_index} to circuit {circuits[second_index]}"
      circuits[second_index].node_indices.add(first_index)
      circuits[first_index] = circuits[second_index]
    elif first_index in circuits and second_index notin circuits:
      circuits[first_index].node_indices.add(second_index)
      circuits[second_index] = circuits[first_index]

    # Both indices are in a circuit, merge the circuits.
    else:
      assert first_index in circuits and second_index in circuits
      if circuits[first_index] == circuits[second_index]:
        # echo fmt"circuits {first_index} and {second_index} are already merged"
        continue
      # echo fmt"merging circuits {circuits[first_index]} and {circuits[second_index]}"
      let circuit = circuits[first_index]
      circuit.node_indices.add(circuits[second_index].node_indices)
      for node_index in circuit.node_indices:
        circuits[node_index] = circuit
    # echo fmt"circuits: {circuits}"

  var resultSet = initHashSet[Circuit]()
  for circuit in circuits.values():
    resultSet.incl(circuit)
  return resultSet.toSeq()

proc solve(input: string): int =
  let coordinates = parse_input(input)
  let connections = find_connections(coordinates, NumConnections)
  let circuits = find_circuits(connections)
  let sorted_circuits = circuits.sorted(proc(a: Circuit, b: Circuit): int = a.node_indices.len - b.node_indices.len, order=SortOrder.Descending)
  let sizes = sorted_circuits.map(proc(c: Circuit): int = c.node_indices.len)
  let top_sizes = sizes[0..<NumLargestCircuits]
  result = top_sizes.prod()
  # echo fmt"connections: {connections}"
  echo fmt"top sizes: {top_sizes}"
  # echo fmt"sorted_circuits: {sorted_circuits[0..<10]}"

when isMainModule:
  let data = readFile($InputFile)
  let answer = solve(data)
  echo fmt"Day {Day} Part {Part}: {answer}"
