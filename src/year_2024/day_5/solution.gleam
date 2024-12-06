import aoc.{type Problem}
import gleam/dict
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

  let rules =
    string.split(rules, "\n")
    |> list.fold(dict.new(), fn(acc, rule) {
      let assert [a, b] = string.split(rule, "|")

      dict.insert(acc, Rule(aoc.int_or_panic(a), aoc.int_or_panic(b)), True)
      |> dict.insert(Rule(aoc.int_or_panic(b), aoc.int_or_panic(a)), False)
    })

  let updates: Updates =
    string.split(updates, "\n")
    |> list.map(fn(line) {
      string.split(line, ",") |> list.map(aoc.int_or_panic)
    })

  list.map(updates, fn(update) {
    let rules =
      list.window(update, 2)
      |> list.map(fn(update) {
        let assert [a, b] = update
        Rule(a, b)
      })

    #(update, rules)
  })
  |> list.filter(fn(update) {
    list.all(update.1, fn(rule) {
      case dict.get(rules, rule) {
        Ok(True) -> True
        Error(_) -> True
        _ -> False
      }
    })
  })
  |> list.map(fn(update) {
    let middle = list.length(update.0) / 2

    list.drop(update.0, middle) |> list.first()
  })
  |> list.fold(0, fn(acc, value) {
    let assert Ok(value) = value

    value + acc
  })
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  aoc.header(2024, 5)

  aoc.problem(aoc.Test, 2024, 5, 1) |> aoc.expect(143) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 5, 1) |> aoc.expect(7365) |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2024, 5, 2) |> aoc.expect(0) |> aoc.run(part2)
}
