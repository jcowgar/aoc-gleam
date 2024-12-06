import aoc
import gleam/int
import gleam/io
import gleam/list

type Move {
  Forward(steps: Int)
  Down(steps: Int)
  Up(steps: Int)
}

type Location {
  Location(horizontal: Int, depth: Int, aim: Int)
}

fn int(value: String) -> Int {
  case int.parse(value) {
    Ok(v) -> v
    Error(_) -> {
      io.println_error("could not parse integer `" <> value <> "`")

      panic
    }
  }
}

fn parse_line(line: String) -> Result(Move, String) {
  case line {
    "forward " <> count -> Ok(Forward(int(count)))
    "down " <> count -> Ok(Down(int(count)))
    "up " <> count -> Ok(Up(int(count)))
    _ -> Error("could not parse line `" <> line <> "`")
  }
}

fn solve(problem: aoc.Problem(Int), fold_fn: fn(Location, Move) -> Location) {
  let final_location =
    aoc.input_line_mapper(problem, parse_line)
    |> list.fold(Location(0, 0, 0), fold_fn)

  final_location.depth * final_location.horizontal
}

fn part1(problem: aoc.Problem(Int)) -> Int {
  solve(problem, fn(loc, move) {
    case move {
      Forward(count) -> Location(..loc, horizontal: loc.horizontal + count)
      Up(count) -> Location(..loc, depth: loc.depth - count)
      Down(count) -> Location(..loc, depth: loc.depth + count)
    }
  })
}

fn part2(problem: aoc.Problem(Int)) -> Int {
  solve(problem, fn(loc, move) {
    case move {
      Forward(count) ->
        Location(
          ..loc,
          horizontal: loc.horizontal + count,
          depth: { loc.aim * count } + loc.depth,
        )
      Up(count) -> Location(..loc, aim: loc.aim - count)
      Down(count) -> Location(..loc, aim: loc.aim + count)
    }
  })
}

pub fn main() {
  io.println("")

  aoc.problem(aoc.Test, 2021, 2, 1) |> aoc.expect(150) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2021, 2, 1) |> aoc.expect(1_947_824) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2021, 2, 1) |> aoc.expect(900) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2021, 2, 2)
  |> aoc.expect(1_813_062_561)
  |> aoc.run(part2)
}
