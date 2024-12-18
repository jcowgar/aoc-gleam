import aoc.{type Problem}
import gleam/list
import gleam/order
import gleam/result
import gleam/set
import gleam/string

type Update =
  List(Int)

fn parse_rules(rules) {
  string.split(rules, "\n")
  |> list.fold(set.new(), fn(acc, rule) {
    let assert [a, b] = string.split(rule, "|")

    set.insert(acc, #(aoc.int(b), aoc.int(a)))
  })
}

fn parse_updates(updates) {
  string.split(updates, "\n")
  |> list.map(fn(line) { string.split(line, ",") |> list.map(aoc.int) })
}

fn parse_input(input: String) -> #(set.Set(#(Int, Int)), List(Update)) {
  let assert [rule_lines, update_lines] =
    string.split(input, "\n\n") |> list.map(string.trim)

  #(parse_rules(rule_lines), parse_updates(update_lines))
}

fn is_valid(rules, sequence) {
  set.contains(rules, sequence) == False
}

/// Create a list of sequences that contain all values after it
/// and the value itself.
///
fn sequences(values, acc) {
  case values {
    [] -> acc |> list.reverse()
    [a, ..rest] ->
      list.flatten([sequence_loop(a, rest, []), sequences(rest, [])])
  }
}

fn sequence_loop(head, rest, acc) {
  case rest {
    [] -> acc |> list.reverse()
    [a, ..rest] -> sequence_loop(head, rest, [#(head, a), ..acc])
  }
}

fn validate_updates(rules, updates) {
  list.map(updates, fn(update) { #(update, sequences(update, [])) })
  |> list.map(fn(update) {
    #(list.all(update.1, fn(sequence) { is_valid(rules, sequence) }), update)
  })
}

fn updates_where(
  updates: List(#(Bool, #(List(Int), List(#(Int, Int))))),
  valid valid,
) {
  list.filter_map(updates, fn(update) {
    case update.0 == valid {
      True -> Ok(update.1.0)
      False -> Error(Nil)
    }
  })
}

fn sum_middle_values(values) {
  list.fold(values, 0, fn(acc, update) {
    acc
    + {
      list.drop(update, list.length(update) / 2)
      |> list.first()
      |> result.unwrap(0)
    }
  })
}

fn part1(problem: Problem(Int)) -> Int {
  let #(rules, updates) = parse_input(problem.input)

  validate_updates(rules, updates)
  |> updates_where(valid: True)
  |> sum_middle_values()
}

fn part2(problem: Problem(Int)) -> Int {
  let #(rules, updates) = parse_input(problem.input)

  validate_updates(rules, updates)
  |> updates_where(valid: False)
  |> list.map(fn(update) {
    list.sort(update, fn(a, b) {
      case is_valid(rules, #(a, b)) {
        True -> order.Lt
        False -> order.Gt
      }
    })
  })
  |> sum_middle_values()
}

pub fn main() {
  aoc.header(2024, 5)

  aoc.sample(2024, 5, 1, 1) |> aoc.expect(143) |> aoc.run(part1)
  aoc.problem(2024, 5, 1) |> aoc.expect(7365) |> aoc.run(part1)

  aoc.sample(2024, 5, 1, 1) |> aoc.expect(123) |> aoc.run(part2)
  aoc.problem(2024, 5, 2) |> aoc.expect(5770) |> aoc.run(part2)
}
