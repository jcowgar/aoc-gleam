import aoc.{type Problem}
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/string

const re_within_brackets_str = "\\[([^\\]]+)\\]"

fn is_abba(line: String) -> Bool {
  string.to_graphemes(line)
  |> list.window(4)
  |> list.any(fn(window) {
    case window {
      [a, b, c, d] -> a == d && b == c && a != b
      _ -> False
    }
  })
}

fn values_from_matches(matches: regexp.Match) -> String {
  let assert regexp.Match(_, [Some(m)]) = matches

  m
}

fn part1(problem: Problem(Int)) -> Int {
  let assert Ok(re_within_brackets) = regexp.from_string(re_within_brackets_str)
  let abbas =
    regexp.replace(re_within_brackets, problem.input, "-")
    |> string.split("\n")
    |> list.map(is_abba)
  let negate_abbas =
    string.split(problem.input, "\n")
    |> list.map(fn(line) {
      re_within_brackets
      |> regexp.scan(line)
      |> list.map(values_from_matches)
      |> string.join("-")
    })
    |> list.map(is_abba)

  list.zip(abbas, negate_abbas)
  |> list.count(fn(a) { a.0 && !a.1 })
}

fn only_abas(pairs: List(String)) -> List(#(String, String)) {
  list.window(pairs, 3)
  |> list.filter_map(fn(window) {
    case window {
      [a, b, c] if a == c && a != b -> Ok(#(a, b))
      _ -> Error(Nil)
    }
  })
}

fn part2(problem: Problem(Int)) -> Int {
  let assert Ok(re_within_brackets) = regexp.from_string(re_within_brackets_str)
  let abas =
    regexp.replace(re_within_brackets, problem.input, "-")
    |> string.split("\n")
    |> list.map(fn(line) { line |> string.to_graphemes |> only_abas() })
  let babs =
    string.split(problem.input, "\n")
    |> list.map(fn(line) {
      regexp.scan(re_within_brackets, line)
      |> list.map(values_from_matches)
      |> string.join("-")
      |> string.to_graphemes()
      |> only_abas()
    })

  list.zip(abas, babs)
  |> list.count(fn(pairs) {
    list.any(pairs.0, fn(a) {
      list.any(pairs.1, fn(b) { a.0 == b.1 && a.1 == b.0 })
    })
  })
}

pub fn main() {
  aoc.header(2016, 7)

  aoc.sample(2016, 7, 1, 1) |> aoc.expect(2) |> aoc.run(part1)
  aoc.problem(2016, 7, 1) |> aoc.expect(110) |> aoc.run(part1)

  aoc.sample(2016, 7, 2, 2) |> aoc.expect(3) |> aoc.run(part2)
  aoc.problem(2016, 7, 2) |> aoc.expect(242) |> aoc.run(part2)
}
