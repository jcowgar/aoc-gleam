import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/string

fn concat_ints(a: Int, b: Int) -> Int {
  case True {
    _ if b >= 1000 -> a * 10_000 + b
    _ if b >= 100 -> a * 1000 + b
    _ if b >= 10 -> a * 100 + b
    _ if b >= 0 -> a * 10 + b
    _ ->
      panic as {
        "code does not exist to concat "
        <> int.to_string(a)
        <> " and "
        <> int.to_string(b)
      }
  }
}

fn parse_line(line: String) -> Result(#(Int, List(Int)), Nil) {
  let assert Ok(#(test_value_str, numbers_str)) = string.split_once(line, ": ")
  let numbers = numbers_str |> string.split(" ") |> list.map(aoc.int)

  Ok(#(aoc.int(test_value_str), numbers))
}

fn is_valid(combo: Bool, test_value, acc, remaining: List(Int)) {
  case remaining {
    [] -> test_value == acc
    [head, ..rest] ->
      is_valid(combo, test_value, acc + head, rest)
      || is_valid(combo, test_value, acc * head, rest)
      || { combo && is_valid(combo, test_value, concat_ints(acc, head), rest) }
  }
}

fn solve(problem: Problem(Int), include_combinator: Bool) -> Int {
  aoc.input_line_mapper(problem, parse_line)
  |> list.filter(fn(c) {
    let assert [hd, ..rest] = c.1

    is_valid(include_combinator, c.0, hd, rest)
  })
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

  aoc.sample(2024, 7, 1, 1) |> aoc.expect(3749) |> aoc.run(part1)
  aoc.problem(2024, 7, 1)
  |> aoc.expect(42_283_209_483_350)
  |> aoc.run(part1)

  aoc.sample(2024, 7, 1, 1) |> aoc.expect(11_387) |> aoc.run(part2)
  aoc.problem(2024, 7, 2)
  |> aoc.expect(1_026_766_857_276_279)
  |> aoc.run(part2)
}
