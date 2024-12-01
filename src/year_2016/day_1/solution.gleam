import aoc.{type Problem}
import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string

type Answer =
  Int

type Move {
  Left(count: Int)
  Right(count: Int)
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

fn int_or_panic(value: String) -> Int {
  case int.parse(value) {
    Ok(v) -> v
    _ -> {
      io.println_error("could not parse the integer value '" <> value <> "'")
      panic
    }
  }
}

fn parse_block_instruction(instruction: String) -> Move {
  case instruction {
    "L" <> count -> Left(int_or_panic(count))
    "R" <> count -> Right(int_or_panic(count))
    _ -> {
      io.println_error("count not parse instruction '" <> instruction <> "'")

      panic
    }
  }
}

fn move(person: Person, move: Move) -> Person {
  let new_direction = case move {
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

fn part1(problem: Problem(Answer)) -> Answer {
  let final_location =
    string.split(problem.input, ", ")
    |> list.map(parse_block_instruction)
    |> list.fold(Person(North, 0, 0), move)

  int.absolute_value(final_location.x) + int.absolute_value(final_location.y)
}

fn part2(problem: Problem(Answer)) -> Answer {
  let final_location =
    string.split(problem.input, ", ")
    |> list.map(parse_block_instruction)
    |> list.fold_until(
      #(set.new() |> set.insert(#(0, 0)), Person(North, 0, 0)),
      fn(acc, m) {
        let new_location = move(acc.1, m)

        case set.contains(acc.0, #(new_location.x, new_location.y)) {
          True -> list.Stop(#(acc.0, new_location))
          False ->
            list.Continue(#(
              set.insert(acc.0, #(new_location.x, new_location.y)),
              new_location,
            ))
        }
      },
    )

  int.absolute_value({ final_location.1 }.x)
  + int.absolute_value({ final_location.1 }.y)
}

pub fn main() {
  aoc.header(2016, 1)
  aoc.problem(aoc.Test, 2016, 1, 1) |> aoc.expect(5) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2016, 1, 2) |> aoc.expect(2) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2016, 1, 3) |> aoc.expect(12) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2016, 1, 1) |> aoc.expect(239) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2016, 1, 4) |> aoc.expect(4) |> aoc.run(part2)
  // aoc.problem(aoc.Actual, 2016, 1, 2) |> aoc.run(part2)
}
