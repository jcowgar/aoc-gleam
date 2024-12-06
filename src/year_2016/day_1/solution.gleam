import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import gleam/string

type Move {
  Left(count: Int)
  Right(count: Int)
  Forward(count: Int)
}

type Direction {
  North
  East
  South
  West
}

type Person {
  Person(direction: Direction, x: Int, y: Int)
}

fn parse_block_instruction(instruction: String) -> Move {
  case instruction {
    "L" <> count -> Left(aoc.int(count))
    "R" <> count -> Right(aoc.int(count))
    _ -> panic as { "count not parse instruction '" <> instruction <> "'" }
  }
}

fn move(person: Person, move: Move) -> Person {
  let new_direction = case move {
    Forward(_) -> person.direction
    Left(_) ->
      case person.direction {
        North -> West
        East -> North
        South -> East
        West -> South
      }

    Right(_) ->
      case person.direction {
        North -> East
        East -> South
        South -> West
        West -> North
      }
  }

  case new_direction {
    North -> Person(new_direction, person.x, person.y - move.count)
    East -> Person(new_direction, person.x + move.count, person.y)
    South -> Person(new_direction, person.x, person.y + move.count)
    West -> Person(new_direction, person.x - move.count, person.y)
  }
}

fn expand_instruction(move: Move) -> List(Move) {
  let forward_moves =
    list.repeat(0, move.count - 1) |> list.map(fn(_) { Forward(1) })
  let base_move = case move {
    Left(_) -> Left(1)
    Right(_) -> Right(1)
    Forward(_) -> panic as "base move should never be forward"
  }

  [base_move, ..forward_moves]
}

fn parse(input: String) -> List(Move) {
  string.split(input, ", ")
  |> list.flat_map(fn(input) {
    input |> parse_block_instruction() |> expand_instruction()
  })
}

fn add(a n1: Int, b n2: Int) -> Int {
  n1 + n2
}

fn test_parser() {
  let assert 11 = add(6, a: 5)

  let assert [Left(1), Forward(1), Forward(1)] = parse("L3")
  let assert [Right(1), Forward(1)] = parse("R2")
  let assert [Right(1)] = parse("R1")
}

fn part1(problem: Problem(Int)) -> Int {
  let final_location =
    problem.input |> parse |> list.fold(Person(North, 0, 0), move)

  int.absolute_value(final_location.x) + int.absolute_value(final_location.y)
}

fn part2(problem: Problem(Int)) -> Int {
  let first_dupe_xy =
    problem.input
    |> parse()
    |> list.fold_until(
      #(set.new() |> set.insert(#(0, 0)), Person(North, 0, 0)),
      fn(acc, m) {
        let new_location = move(acc.1, m)
        let xy = #(new_location.x, new_location.y)

        case set.contains(acc.0, xy) {
          True -> list.Stop(#(acc.0, new_location))
          False -> list.Continue(#(set.insert(acc.0, xy), new_location))
        }
      },
    )
    |> pair.second()

  int.absolute_value(first_dupe_xy.x) + int.absolute_value(first_dupe_xy.y)
}

pub fn main() {
  test_parser()

  aoc.header(2016, 1)
  aoc.problem(aoc.Test, 2016, 1, 1) |> aoc.expect(5) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2016, 1, 2) |> aoc.expect(2) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2016, 1, 3) |> aoc.expect(12) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2016, 1, 1) |> aoc.expect(239) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2016, 1, 4) |> aoc.expect(4) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2016, 1, 2) |> aoc.expect(141) |> aoc.run(part2)
}
