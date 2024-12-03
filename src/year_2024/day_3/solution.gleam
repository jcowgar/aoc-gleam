import aoc.{type Problem}
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/regexp.{Match}

fn solve(pattern: String, line: String) -> Int {
  let assert Ok(r) = regexp.from_string(pattern)

  regexp.scan(r, line)
  |> list.fold(#(True, 0), fn(acc, match) {
    case match {
      Match("do()", _) -> #(True, acc.1)
      Match("don't()", _) -> #(False, acc.1)
      Match(_, [Some(a), Some(b)]) if acc.0 -> #(
        True,
        acc.1 + { aoc.int_or_panic(a) * aoc.int_or_panic(b) },
      )
      _ -> acc
    }
  })
  |> pair.second()
}

fn part1(problem: Problem(Int)) -> Int {
  solve("mul\\((\\d{1,3}),(\\d{1,3})\\)", problem.input)
}

fn part2(problem: Problem(Int)) -> Int {
  solve("mul\\((\\d{1,3}),(\\d{1,3})\\)|do\\(\\)|don't\\(\\)", problem.input)
}

pub fn main() {
  aoc.header(2024, 3)

  aoc.problem(aoc.Test, 2024, 3, 1) |> aoc.expect(161) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 3, 1)
  |> aoc.expect(187_833_789)
  |> aoc.run(part1)

  aoc.problem(aoc.Test, 2024, 3, 2) |> aoc.expect(48) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2024, 3, 2)
  |> aoc.expect(94_455_185)
  |> aoc.run(part2)
}
