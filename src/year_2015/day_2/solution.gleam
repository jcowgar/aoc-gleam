import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp.{Match}
import gleam/result

fn part1(problem: Problem(Int)) -> Int {
  let assert Ok(re_lwh) = regexp.from_string("(\\d+)x(\\d+)x(\\d+)")

  aoc.input_line_mapper(problem, fn(line) {
    regexp.scan(re_lwh, line)
    |> list.map(fn(match) {
      let assert Match(_, [Some(l), Some(w), Some(h)]) = match

      let l = aoc.int_or_panic(l)
      let w = aoc.int_or_panic(w)
      let h = aoc.int_or_panic(h)

      let additional_sqft =
        [l * w, w * h, h * l]
        |> list.sort(int.compare)
        |> list.first()
        |> result.unwrap(0)

      { 2 * l * w } + { 2 * w * h } + { 2 * h * l } + additional_sqft
    })
    |> Ok()
  })
  |> list.flatten()
  |> int.sum()
}

fn part2(problem: Problem(Int)) -> Int {
  let assert Ok(re_lwh) = regexp.from_string("(\\d+)x(\\d+)x(\\d+)")

  aoc.input_line_mapper(problem, fn(line) {
    regexp.scan(re_lwh, line)
    |> list.map(fn(match) {
      let assert Match(_, [Some(l), Some(w), Some(h)]) = match

      let l = aoc.int_or_panic(l)
      let w = aoc.int_or_panic(w)
      let h = aoc.int_or_panic(h)

      let #(_, a, b) =
        [#(l * w, l, w), #(w * h, w, h), #(h * l, h, l)]
        |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
        |> list.first()
        |> result.unwrap(#(0, 0, 0))

      { a + a + b + b } + l * w * h
    })
    |> Ok()
  })
  |> list.flatten()
  |> int.sum()
}

pub fn main() {
  aoc.header(2015, 2)

  aoc.problem(aoc.Test, 2015, 2, 1) |> aoc.expect(101) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2015, 2, 1) |> aoc.expect(1_606_483) |> aoc.run(part1)

  aoc.problem(aoc.Test, 2015, 2, 1) |> aoc.expect(48) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2015, 2, 2) |> aoc.expect(3_842_356) |> aoc.run(part2)
}
