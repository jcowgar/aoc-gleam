import aoc.{type Problem}
import gleam/io
import gleam/list
import gleam/result
import gleam/string

type Island {
  Island(points: List(Int), width: Int, height: Int)
}

fn parse_data(input: String) -> Island {
  let lines = string.split(input, "\n")

  let points =
    lines
    |> list.flat_map(fn(line) {
      line |> string.to_graphemes() |> list.map(aoc.int)
    })

  Island(
    points,
    string.length(list.first(lines) |> result.unwrap("")),
    list.length(lines),
  )
}

fn part1(problem: Problem(Int)) -> Int {
  let island = parse_data(problem.input)

  -1
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   -1
// }

pub fn main() {
  aoc.header(2024, 10)

  aoc.sample(2024, 10, 1, 1) |> aoc.expect(36) |> aoc.run(part1)
  // aoc.problem(2024, 10, 1) |> aoc.expect(0) |> aoc.run(part1)

  // aoc.sample(2024, 10, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
  // aoc.problem(2024, 10, 2) |> aoc.expect(0) |> aoc.run(part2)
}
// NOTES: full input data is a 45x45 grid, or 2025 points.
