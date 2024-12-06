import aoc
import gleam/int
import gleam/io
import gleam/list
import gleam/string

type BitPopularity {
  BitPopularity(zero: Int, one: Int)
}

fn int(value: String) -> Int {
  case int.parse(value) {
    Ok(v) -> v
    Error(e) -> {
      io.println_error(string.inspect(e))

      panic
    }
  }
}

fn most_common(b: BitPopularity) -> Int {
  case True {
    _ if b.zero > b.one -> 0
    _ if b.zero < b.one -> 1
    _ -> 1
  }
}

fn least_common(b: BitPopularity) -> Int {
  case True {
    _ if b.zero < b.one -> 0
    _ if b.zero > b.one -> 1
    _ -> 0
  }
}

fn inc_bit(bp: BitPopularity, value) {
  case value {
    0 -> BitPopularity(bp.zero + 1, bp.one)
    1 -> BitPopularity(bp.zero, bp.one + 1)
    _ -> panic
  }
}

fn part1(problem: aoc.Problem(Int)) -> Int {
  let lines =
    problem.input
    |> string.split("\n")
    |> list.map(fn(v) { string.split(v, "") |> list.map(int) })
  let assert [head, ..] = lines
  let acc = list.map(head, fn(_) { BitPopularity(0, 0) })
  let result =
    list.fold(lines, acc, fn(acc, line) {
      list.zip(acc, line) |> list.map(fn(v) { inc_bit(v.0, v.1) })
    })
  let assert Ok(most_common) =
    list.map(result, fn(r) { most_common(r) |> int.to_string() })
    |> string.join("")
    |> int.base_parse(2)
  let assert Ok(least_common) =
    list.map(result, fn(r) { least_common(r) |> int.to_string() })
    |> string.join("")
    |> int.base_parse(2)

  most_common * least_common
}

// fn part2(_problem: aoc.Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  io.println("")

  aoc.problem(aoc.Test, 2021, 3, 1) |> aoc.expect(198) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2021, 3, 1) |> aoc.expect(1_131_506) |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2021, 3, 2) |> aoc.expect(7_863_147) |> aoc.run(part2)
}
