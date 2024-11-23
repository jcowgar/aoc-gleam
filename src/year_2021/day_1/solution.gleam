import aoc
import gleam/int
import gleam/io
import gleam/list

fn count_increases(last: Int, remaining: List(Int), acc: Int) -> Int {
  case remaining {
    [head, ..rest] if last < head -> count_increases(head, rest, acc + 1)
    [head, ..rest] -> count_increases(head, rest, acc)
    [] -> acc
  }
}

fn list_sum(l: List(Int), acc: Int) -> Int {
  case l {
    [hd, ..rest] -> list_sum(rest, hd + acc)
    [] -> acc
  }
}

fn part1(problem: aoc.Problem(Int)) -> Int {
  let assert [head, ..rest] = aoc.input_line_mapper(problem, int.parse)

  count_increases(head, rest, 0)
}

fn part2(problem: aoc.Problem(Int)) -> Int {
  let assert [head, ..rest] =
    aoc.input_line_mapper(problem, int.parse)
    |> list.window(3)
    |> list.map(fn(window) { list_sum(window, 0) })

  count_increases(head, rest, 0)
}

pub fn main() {
  io.println("")

  aoc.problem(aoc.Test, 2021, 1, 1) |> aoc.expect(7) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2021, 1, 1) |> aoc.expect(1288) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2021, 1, 2) |> aoc.expect(1311) |> aoc.run(part2)
}
