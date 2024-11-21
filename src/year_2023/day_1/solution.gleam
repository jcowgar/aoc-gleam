import aoc
import gleam/int
import gleam/list
import gleam/string

fn collect_numbers(remaining, acc) {
  case remaining {
    "" -> list.reverse(acc)
    "0" <> rest -> collect_numbers(rest, ["0", ..acc])
    "1" <> rest -> collect_numbers(rest, ["1", ..acc])
    "2" <> rest -> collect_numbers(rest, ["2", ..acc])
    "3" <> rest -> collect_numbers(rest, ["3", ..acc])
    "4" <> rest -> collect_numbers(rest, ["4", ..acc])
    "5" <> rest -> collect_numbers(rest, ["5", ..acc])
    "6" <> rest -> collect_numbers(rest, ["6", ..acc])
    "7" <> rest -> collect_numbers(rest, ["7", ..acc])
    "8" <> rest -> collect_numbers(rest, ["8", ..acc])
    "9" <> rest -> collect_numbers(rest, ["9", ..acc])
    _ -> collect_numbers(string.drop_start(remaining, 1), acc)
  }
}

fn collect_numbers_2(remaining, acc) {
  case remaining {
    "" -> list.reverse(acc)
    "0" <> rest -> collect_numbers_2(rest, ["0", ..acc])
    "1" <> rest -> collect_numbers_2(rest, ["1", ..acc])
    "2" <> rest -> collect_numbers_2(rest, ["2", ..acc])
    "3" <> rest -> collect_numbers_2(rest, ["3", ..acc])
    "4" <> rest -> collect_numbers_2(rest, ["4", ..acc])
    "5" <> rest -> collect_numbers_2(rest, ["5", ..acc])
    "6" <> rest -> collect_numbers_2(rest, ["6", ..acc])
    "7" <> rest -> collect_numbers_2(rest, ["7", ..acc])
    "8" <> rest -> collect_numbers_2(rest, ["8", ..acc])
    "9" <> rest -> collect_numbers_2(rest, ["9", ..acc])
    "zero" <> rest -> collect_numbers_2("o" <> rest, ["0", ..acc])
    "one" <> rest -> collect_numbers_2("e" <> rest, ["1", ..acc])
    "two" <> rest -> collect_numbers_2("o" <> rest, ["2", ..acc])
    "three" <> rest -> collect_numbers_2("e" <> rest, ["3", ..acc])
    "four" <> rest -> collect_numbers_2("r" <> rest, ["4", ..acc])
    "five" <> rest -> collect_numbers_2("e" <> rest, ["5", ..acc])
    "six" <> rest -> collect_numbers_2("x" <> rest, ["6", ..acc])
    "seven" <> rest -> collect_numbers_2("n" <> rest, ["7", ..acc])
    "eight" <> rest -> collect_numbers_2("t" <> rest, ["8", ..acc])
    "nine" <> rest -> collect_numbers_2("e" <> rest, ["9", ..acc])
    _ -> collect_numbers_2(string.drop_start(remaining, 1), acc)
  }
}

pub fn solve(input: String, number_collector) {
  string.split(input, "\n")
  |> list.fold(0, fn(acc, line) {
    let numbers = line |> number_collector([])

    let assert Ok(first) = list.first(numbers)
    let assert Ok(last) = list.last(numbers)
    let assert Ok(result) = { first <> last } |> int.parse()

    result + acc
  })
}

type MyProblem =
  aoc.Problem(Int)

fn part1(problem: MyProblem) {
  solve(problem.input, collect_numbers)
}

fn part2(problem: MyProblem) {
  solve(problem.input, collect_numbers_2)
}

pub fn main() {
  aoc.problem(aoc.Test, 2023, 1, 1)
  |> aoc.expect(142)
  |> aoc.run(part1)

  aoc.problem(aoc.Actual, 2023, 1, 1)
  |> aoc.expect(54_644)
  |> aoc.run(part1)

  aoc.problem(aoc.Test, 2023, 1, 2)
  |> aoc.expect(281)
  |> aoc.run(part2)

  aoc.problem(aoc.Actual, 2023, 1, 2)
  |> aoc.expect(53_348)
  |> aoc.run(part2)
}
