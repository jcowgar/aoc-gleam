import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/regexp

fn parse_triangle(line: String) -> Result(#(Bool, Int, Int, Int), Nil) {
  let assert Ok(re) = regexp.from_string("\\s+")

  let assert [a, b, c] =
    re
    |> regexp.split(line)
    |> list.filter_map(fn(a) {
      case a {
        "" -> Error(Nil)
        _ -> aoc.int_or_panic(a) |> Ok()
      }
    })
    |> list.sort(int.compare)

  Ok(#(a + b > c, a, b, c))
}

fn part1(problem: Problem(Int)) -> Int {
  aoc.input_line_mapper(problem, parse_triangle)
  |> list.count(fn(triangle) { triangle.0 })
}

fn is_valid_triangle(sides: List(Int)) -> Bool {
  let assert [a, b, c] = sides |> list.sort(int.compare)

  a + b > c
}

fn parse_triangle_2(line: String) -> Result(List(Int), Nil) {
  let assert Ok(re) = regexp.from_string("\\s+")

  let assert [a, b, c] =
    re
    |> regexp.split(line)
    |> list.filter_map(fn(a) {
      case a {
        "" -> Error(Nil)
        _ -> aoc.int_or_panic(a) |> Ok()
      }
    })

  [a, b, c] |> Ok()
}

fn part2(problem: Problem(Int)) -> Int {
  aoc.input_line_mapper(problem, parse_triangle_2)
  |> list.sized_chunk(3)
  |> list.map(list.transpose)
  |> list.flatten()
  |> list.count(is_valid_triangle)
}

pub fn main() {
  aoc.header(2016, 3)

  aoc.problem(aoc.Test, 2016, 3, 1) |> aoc.expect(0) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2016, 3, 1) |> aoc.expect(869) |> aoc.run(part1)

  aoc.problem(aoc.Test, 2016, 3, 2) |> aoc.expect(6) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2016, 3, 2) |> aoc.expect(1544) |> aoc.run(part2)
}
