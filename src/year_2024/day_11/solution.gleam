import aoc.{type Problem}
import gleam/list.{Continue, Stop}
import gleam/string

const thresholds = [
  10, 1000, 100_000, 10_000_000, 1_000_000_000, 100_000_000_000,
]

fn maybe_split(value: Int) -> Result(#(Int, Int), Nil) {
  let divisor =
    list.fold_until(thresholds, 10, fn(acc, threshold) {
      case value < threshold, value < threshold * 10 {
        True, _ -> Stop(-1)
        False, False -> Continue(acc * 10)
        False, True -> Stop(acc)
      }
    })

  case divisor >= 0 {
    True -> Ok(#(value / divisor, value % divisor))
    False -> Error(Nil)
  }
}

fn test_maybe_split() {
  let assert Error(Nil) = maybe_split(501)
  let assert Ok(#(50, 1)) = maybe_split(5001)
  let assert Ok(#(50, 0)) = maybe_split(5000)
}

fn split_stone(stone: Int) -> List(Int) {
  case stone {
    0 -> [1]
    _ -> {
      case maybe_split(stone) {
        Ok(#(a, b)) -> [a, b]
        Error(_) -> [stone * 2024]
      }
    }
  }
}

fn solve(arrangement, count) {
  case count {
    0 -> arrangement
    _ ->
      arrangement
      |> list.flat_map(fn(stone) { stone |> split_stone() })
      |> solve(count - 1)
  }
}

fn part1(problem: Problem(Int)) -> Int {
  string.split(problem.input, " ")
  |> list.map(aoc.int)
  |> solve(25)
  |> list.length()
}

fn part2(problem: Problem(Int)) -> Int {
  string.split(problem.input, " ")
  |> list.map(aoc.int)
  |> solve(75)
  |> list.length()
}

pub fn main() {
  let _ = test_maybe_split()

  aoc.header(2024, 11)

  aoc.problem(aoc.Test, 2024, 11, 1) |> aoc.expect(55_312) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 11, 1) |> aoc.expect(220_722) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 11, 2) |> aoc.expect(0) |> aoc.run(part2)
}
