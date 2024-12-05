import aoc.{type Problem}
import gleam/io
import gleam/list
import gleam/string

type Rule {
  Rule(page: Int, before: Int)
}

type Update =
  List(Int)

type Updates =
  List(Update)

fn part1(problem: Problem(Int)) -> Int {
  let assert [rules, updates] =
    string.split(problem.input, "\n\n") |> list.map(string.trim)

  let rules: List(Rule) =
    string.split(rules, "\n")
    |> list.map(fn(rule) {
      let assert [a, b] = string.split(rule, "|")

      Rule(aoc.int_or_panic(a), aoc.int_or_panic(b))
    })

  let updates: Updates =
    string.split(updates, "\n")
    |> list.map(fn(line) {
      string.split(line, ",") |> list.map(aoc.int_or_panic)
    })

  io.debug(rules)
  io.debug(updates)

  list.map(updates, fn(update) { todo })

  0
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  aoc.header(2024, 5)

  aoc.problem(aoc.Test, 2024, 5, 1) |> aoc.expect(143) |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2024, 5, 1) |> aoc.expect(0) |> aoc.run(part1)

  // aoc.problem(aoc.Actual, 2024, 5, 2) |> aoc.expect(0) |> aoc.run(part2)
}
