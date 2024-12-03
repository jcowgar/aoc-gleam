import aoc.{type Problem}
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/regexp
import gleam/string

fn to_pairs(value: String) -> List(#(String, String)) {
  let assert [last, ..rest] =
    value
    |> string.to_graphemes()

  list.fold(rest, #(last, []), fn(acc, ch) { #(ch, [#(acc.0, ch), ..acc.1]) })
  |> pair.second()
  |> list.reverse()
}

fn is_abba(pairs: List(#(String, String))) -> Bool {
  pairs
  |> list.window(3)
  |> list.any(fn(window) {
    let assert [a, _, b] = window
    a.0 == b.1 && a.1 == b.0 && a.0 != a.1
  })
}

fn grab_matches(matches: regexp.Match) -> String {
  let assert regexp.Match(_, [Some(m)]) = matches

  m
}

fn part1(problem: Problem(Int)) -> Int {
  let assert Ok(re_within_brackets) = regexp.from_string("\\[([^\\]]+)\\]")

  let abbas =
    re_within_brackets
    |> regexp.replace(problem.input, "-")
    |> string.split("\n")
    |> list.map(fn(v) { v |> to_pairs() |> is_abba() })

  let negate_abbas =
    problem.input
    |> string.split("\n")
    |> list.map(fn(line) {
      re_within_brackets
      |> regexp.scan(line)
      |> list.map(grab_matches)
      |> string.join("-")
    })
    |> list.map(to_pairs)
    |> list.map(is_abba)

  list.zip(abbas, negate_abbas)
  |> list.count(fn(a) { a.0 && !a.1 })
}

fn is_aba(pairs: List(String)) -> List(#(Bool, String, String)) {
  pairs
  |> list.window(3)
  |> list.map(fn(window) {
    let assert [a, b, c] = window
    #(a == c && a != b, a, b)
  })
  |> list.filter(fn(v) { v.0 })
}

fn part2(problem: Problem(Int)) -> Int {
  let assert Ok(re_within_brackets) = regexp.from_string("\\[([^\\]]+)\\]")

  let abas =
    re_within_brackets
    |> regexp.replace(problem.input, "-")
    |> string.split("\n")
    |> list.map(fn(line) { line |> string.to_graphemes |> is_aba() })

  let babs =
    problem.input
    |> string.split("\n")
    |> list.map(fn(line) {
      re_within_brackets
      |> regexp.scan(line)
      |> list.map(grab_matches)
      |> string.join("-")
      |> string.to_graphemes()
      |> is_aba()
    })

  list.zip(abas, babs)
  |> list.map(fn(pairs) {
    list.any(pairs.0, fn(a) {
      list.any(pairs.1, fn(b) { a.0 && b.0 && a.1 == b.2 && a.2 == b.1 })
    })
  })
  |> list.count(fn(a) { a })
}

pub fn main() {
  aoc.header(2016, 7)

  aoc.problem(aoc.Test, 2016, 7, 1) |> aoc.expect(2) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2016, 7, 1) |> aoc.expect(110) |> aoc.run(part1)

  aoc.problem(aoc.Test, 2016, 7, 2) |> aoc.expect(3) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2016, 7, 2) |> aoc.expect(242) |> aoc.run(part2)
}
