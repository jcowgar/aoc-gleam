import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/string

fn parse_line(line: String) -> Result(#(Int, List(Int)), Nil) {
  let assert Ok(#(test_value_str, numbers_str)) = string.split_once(line, ":")
  let numbers =
    numbers_str |> string.trim() |> string.split(" ") |> list.map(aoc.int)

  Ok(#(aoc.int(test_value_str), numbers))
}

fn is_valid(include_combinator: Bool, test_value, acc, remaining: List(Int)) {
  case remaining {
    [] if test_value == acc -> True
    [] -> False
    [head, ..rest] ->
      is_valid(include_combinator, test_value, acc + head, rest)
      || is_valid(include_combinator, test_value, acc * head, rest)
      || {
        include_combinator
        && is_valid(
          include_combinator,
          test_value,
          aoc.int(int.to_string(acc) <> int.to_string(head)),
          rest,
        )
      }
  }
}

fn solve(problem: Problem(Int), include_combinator: Bool) -> Int {
  aoc.input_line_mapper(problem, parse_line)
  |> list.filter(fn(c) { is_valid(include_combinator, c.0, 0, c.1) })
  |> list.fold(0, fn(acc, c) { acc + c.0 })
}

fn part1(problem: Problem(Int)) -> Int {
  solve(problem, False)
}

fn part2(problem: Problem(Int)) -> Int {
  solve(problem, True)
}

pub fn main() {
  aoc.header(2024, 7)

  aoc.problem(aoc.Test, 2024, 7, 1) |> aoc.expect(3749) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 7, 1)
  |> aoc.expect(42_283_209_483_350)
  |> aoc.run(part1)

  aoc.problem(aoc.Test, 2024, 7, 1) |> aoc.expect(11_387) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2024, 7, 2)
  |> aoc.expect(1_026_766_857_276_279)
  |> aoc.run(part2)
}
