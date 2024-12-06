import aoc.{type Problem}
import gleam/list
import gleam/pair
import gleam/string

// Safe levels are:
//
// 1. The levels are either all increasing or all decreasing.
// 2. Any two adjacent levels differ by at least one and at most three.

fn is_safe_level_asc(level: List(Int)) -> Bool {
  let assert [head, ..rest] = level

  list.fold_until(rest, #(head, True), fn(acc, b) {
    case b - acc.0 {
      1 | 2 | 3 -> list.Continue(#(b, True))
      _ -> list.Stop(#(head, False))
    }
  })
  |> pair.second()
}

fn is_safe_level(level: List(Int)) -> Bool {
  is_safe_level_asc(level) || list.reverse(level) |> is_safe_level_asc()
}

fn is_safe_level_sorta(level: List(Int)) -> Bool {
  list.combinations(level, list.length(level) - 1)
  |> list.any(is_safe_level)
}

fn parse_report(line: String) -> Result(List(Int), Nil) {
  string.split(line, " ") |> list.map(aoc.int) |> Ok()
}

fn part1(problem: Problem(Int)) -> Int {
  aoc.input_line_mapper(problem, parse_report)
  |> list.map(is_safe_level)
  |> list.count(fn(v) { v })
}

fn part2(problem: Problem(Int)) -> Int {
  aoc.input_line_mapper(problem, parse_report)
  |> list.map(is_safe_level_sorta)
  |> list.count(fn(v) { v })
}

pub fn main() {
  aoc.problem(aoc.Test, 2024, 2, 1) |> aoc.expect(2) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 2, 1) |> aoc.expect(411) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 2, 2) |> aoc.expect(465) |> aoc.run(part2)
}
