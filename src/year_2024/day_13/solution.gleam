import aoc.{type Problem}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
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

fn find_multiplier_pairs(
  num1_1: Int,
  num2_1: Int,
  target_1: Int,
  num1_2: Int,
  num2_2: Int,
  target_2: Int,
) -> List(#(Int, Int)) {
  let range = list.range(1, target_1 / int.min(num1_1, num2_1))

  range
  |> list.fold([], fn(acc, x) {
    range
    |> list.fold(acc, fn(acc, y) {
      case
        num1_1 * x + num2_1 * y == target_1
        && num1_2 * x + num2_2 * y == target_2
      {
        True -> [#(x, y), ..acc]
        False -> acc
      }
    })
  })
}

fn part1(problem: Problem(Int)) -> Int {
  parse_data(problem.input)
  |> list.map(fn(machine) {
    find_multiplier_pairs(
      machine.button_a_move.x,
      machine.button_b_move.x,
      machine.prize.x,
      machine.button_a_move.y,
      machine.button_b_move.y,
      machine.prize.y,
    )
    |> list.map(fn(x) { x.0 * button_a_cost + x.1 * button_b_cost })
    |> list.sort(int.compare)
    |> list.first()
    |> result.unwrap(0)
  })
  |> int.sum()
}

// https://www.1728.org/unknwn2.htm
// https://www.1728.org/cramer.htm
fn cramers_rule(
  a: Int,
  b: Int,
  e: Int,
  c: Int,
  d: Int,
  f: Int,
) -> Option(#(Int, Int)) {
  let det = a * d - b * c

  case det == 0 {
    True -> None
    False -> {
      let x = { e * d - b * f } / det
      let y = { a * f - e * c } / det

      Some(#(x, y))
    }
  }
}

fn part1_cramer(problem: Problem(Int)) -> Int {
  parse_data(problem.input)
  |> list.map(fn(machine) {
    case
      cramers_rule(
        machine.button_a_move.x,
        machine.button_b_move.x,
        machine.prize.x,
        machine.button_a_move.y,
        machine.button_b_move.y,
        machine.prize.y,
      )
    {
      None -> 0
      Some(x) -> {
        let x_total =
          { machine.button_a_move.x * x.0 } + { machine.button_b_move.x * x.1 }
        let y_total =
          { machine.button_a_move.y * x.0 } + { machine.button_b_move.y * x.1 }
        case x_total == machine.prize.x && y_total == machine.prize.y {
          True -> x.0 * button_a_cost + x.1 * button_b_cost
          False -> 0
        }
      }
    }
  })
  |> int.sum()
}

fn part2(problem: Problem(Int)) -> Int {
  parse_data(problem.input)
  |> list.map(fn(machine) {
    let machine =
      Machine(
        Position(machine.button_a_move.x, machine.button_a_move.y),
        Position(machine.button_b_move.x, machine.button_b_move.y),
        Position(
          machine.prize.x + 10_000_000_000_000,
          machine.prize.y + 10_000_000_000_000,
        ),
      )

    case
      cramers_rule(
        machine.button_a_move.x,
        machine.button_b_move.x,
        machine.prize.x,
        machine.button_a_move.y,
        machine.button_b_move.y,
        machine.prize.y,
      )
    {
      None -> 0
      Some(x) -> {
        let x_total =
          { machine.button_a_move.x * x.0 } + { machine.button_b_move.x * x.1 }
        let y_total =
          { machine.button_a_move.y * x.0 } + { machine.button_b_move.y * x.1 }
        case x_total == machine.prize.x && y_total == machine.prize.y {
          True -> x.0 * button_a_cost + x.1 * button_b_cost
          False -> 0
        }
      }
    }
  })
  |> int.sum()
}

pub fn main() {
  aoc.header(2024, 13)

  aoc.sample(2024, 13, 1, 1) |> aoc.expect(480) |> aoc.run(part1)
  aoc.problem(2024, 13, 1) |> aoc.expect(29_388) |> aoc.run(part1)

  aoc.sample(2024, 13, 1, 1) |> aoc.expect(480) |> aoc.run(part1_cramer)
  aoc.problem(2024, 13, 1) |> aoc.expect(29_388) |> aoc.run(part1_cramer)

  aoc.problem(2024, 13, 2) |> aoc.expect(99_548_032_866_004) |> aoc.run(part2)
}
