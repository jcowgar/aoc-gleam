import aoc.{type Problem}
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/string
import rememo/memo

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

fn solve_stone(stone, count, cache) {
  use <- memo.memoize(cache, #(stone, count))

  case count {
    0 -> 1
    _ -> {
      case split_stone(stone) {
        [a, b] ->
          solve_stone(a, count - 1, cache) + solve_stone(b, count - 1, cache)
        [stone] -> solve_stone(stone, count - 1, cache)
        what ->
          panic as {
            "split stone should never return " <> string.inspect(what)
          }
      }
    }
  }
}

fn solve(problem: Problem(Int), blinks: Int) -> Int {
  use cache <- memo.create()

  string.split(problem.input, " ")
  |> list.map(aoc.int)
  |> list.map(fn(stone) { solve_stone(stone, blinks, cache) })
  |> int.sum()
}

fn part1(problem: Problem(Int)) -> Int {
  solve(problem, 25)
}

fn part2(problem: Problem(Int)) -> Int {
  solve(problem, 75)
}

pub fn main() {
  let _ = test_maybe_split()

  aoc.header(2024, 11)

  aoc.sample(2024, 11, 1, 1) |> aoc.expect(55_312) |> aoc.run(part1)
  aoc.problem(2024, 11, 1) |> aoc.expect(220_722) |> aoc.run(part1)

  aoc.sample(2024, 11, 1, 1)
  |> aoc.expect(65_601_038_650_482)
  |> aoc.run(part2)

  aoc.problem(2024, 11, 2)
  |> aoc.expect(261_952_051_690_787)
  |> aoc.run(part2)
}
