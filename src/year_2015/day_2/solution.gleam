import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn part1(problem: Problem(Int)) -> Int {
  aoc.input_line_mapper(problem, fn(line) {
    let assert [l, w, h] = string.split(line, "x") |> list.map(aoc.int)

    let additional_sqft =
      [l * w, w * h, h * l]
      |> list.sort(int.compare)
      |> list.first()
      |> result.unwrap(0)

    { 2 * l * w } + { 2 * w * h } + { 2 * h * l } + additional_sqft
    |> Ok()
  })
  |> int.sum()
}

fn part2(problem: Problem(Int)) -> Int {
  aoc.input_line_mapper(problem, fn(line) {
    let assert [l, w, h] = string.split(line, "x") |> list.map(aoc.int)

    let #(_, a, b) =
      [#(l * w, l, w), #(w * h, w, h), #(h * l, h, l)]
      |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
      |> list.first()
      |> result.unwrap(#(0, 0, 0))

    { a + a + b + b } + l * w * h
    |> Ok()
  })
  |> int.sum()
}

pub fn main() {
  aoc.header(2015, 2)

  aoc.sample(2015, 2, 1, 1) |> aoc.expect(101) |> aoc.run(part1)
  aoc.problem(2015, 2, 1) |> aoc.expect(1_606_483) |> aoc.run(part1)

  aoc.sample(2015, 2, 2, 1) |> aoc.expect(48) |> aoc.run(part2)
  aoc.problem(2015, 2, 2) |> aoc.expect(3_842_356) |> aoc.run(part2)
}
