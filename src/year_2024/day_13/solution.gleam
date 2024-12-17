import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import gleam/string
import support/grid/position.{type Position, Position}

const button_a_cost = 3

const button_b_cost = 1

type Machine {
  Machine(button_a_move: Position, button_b_move: Position, prize: Position)
}

fn parse_machine(raw: String) -> Machine {
  let assert Ok(xy_regex) = regexp.from_string("X.(\\d+), Y.(\\d+)")

  let assert [button_a, button_b, prize] =
    string.split(raw, "\n")
    |> list.map(fn(line) {
      let assert [regexp.Match(_, [Some(x), Some(y)])] =
        regexp.scan(xy_regex, line)

      Position(aoc.int(x), aoc.int(y))
    })

  Machine(button_a, button_b, prize)
}

fn parse_data(input: String) -> List(Machine) {
  string.split(input, "\n\n")
  |> list.map(parse_machine)
}

pub fn find_multiplier_pairs(
  num1: Int,
  num2: Int,
  target: Int,
) -> List(#(Int, Int)) {
  let max_iterations = target / int.min(num1, num2)

  list.range(1, max_iterations)
  |> list.fold([], fn(acc, x) {
    list.range(1, max_iterations)
    |> list.fold(acc, fn(acc, y) {
      case num1 * x + num2 * y == target {
        True -> [#(x, y), ..acc]
        False -> acc
      }
    })
  })
}

fn part1(problem: Problem(Int)) -> Int {
  parse_data(problem.input)
  |> list.map(fn(machine) {
    let x =
      find_multiplier_pairs(
        machine.button_a_move.x,
        machine.button_b_move.x,
        machine.prize.x,
      )
    let y =
      find_multiplier_pairs(
        machine.button_a_move.y,
        machine.button_b_move.y,
        machine.prize.y,
      )

    x
    |> list.fold([], fn(acc, x) {
      case list.contains(y, x) {
        True -> [x.0 * button_a_cost + x.1 * button_b_cost, ..acc]
        False -> acc
      }
    })
    |> list.sort(int.compare)
    |> list.first()
    |> result.unwrap(0)
  })
  |> int.sum()
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   -1
// }

pub fn main() {
  aoc.header(2024, 13)

  aoc.sample(2024, 13, 1, 1) |> aoc.expect(480) |> aoc.run(part1)
  aoc.problem(2024, 13, 1) |> aoc.expect(29_388) |> aoc.run(part1)
  // aoc.sample(2024, 13, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
  // aoc.problem(2024, 13, 2) |> aoc.expect(0) |> aoc.run(part2)
}
// - 320 machines total in real input
// - maximum of 100 button presses are needed (part 1)
