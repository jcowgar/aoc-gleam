import aoc
import gleam/io
import gleam/list
import gleam/string

fn paren_to_int(paren: String) -> Int {
  case paren {
    "(" -> 1
    _ -> -1
  }
}

fn part1(problem: aoc.Problem(Int)) -> Int {
  string.split(problem.input, "")
  |> list.map(paren_to_int)
  |> list.fold(0, fn(a, b) { a + b })
}

fn part2(problem: aoc.Problem(Int)) -> Int {
  let #(index, _) =
    string.split(problem.input, "")
    |> list.map(paren_to_int)
    |> list.fold_until(#(1, 0), fn(a, b) {
      case a.1 + b {
        -1 -> list.Stop(#(a.0, -1))
        floor -> list.Continue(#(a.0 + 1, floor))
      }
    })

  index
}

pub fn main() {
  io.println("")

  aoc.problem(aoc.Actual, 2015, 1, 1) |> aoc.expect(74) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2015, 1, 2) |> aoc.expect(1795) |> aoc.run(part2)
}
