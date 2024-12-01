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
  |> list.fold(0, fn(acc, step) { acc + step })
}

fn part2(problem: aoc.Problem(Int)) -> Int {
  let #(index, _) =
    string.split(problem.input, "")
    |> list.map(paren_to_int)
    // acc.0 = current index in file
    // acc.1 = current floor
    |> list.fold_until(#(1, 0), fn(acc, step) {
      case acc.1 + step {
        -1 -> list.Stop(#(acc.0, -1))
        floor -> list.Continue(#(acc.0 + 1, floor))
      }
    })

  index
}

pub fn main() {
  io.println("")

  aoc.problem(aoc.Actual, 2015, 1, 1) |> aoc.expect(74) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2015, 1, 2) |> aoc.expect(1795) |> aoc.run(part2)
}
