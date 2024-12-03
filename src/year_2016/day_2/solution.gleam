import aoc.{type Problem}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string

const keypad_1 = "
123
456
789"

const keypad_2 = "
  1  
 234 
56789
 ABC 
  D  "

type Move {
  Up
  Down
  Left
  Right
}

fn create_keypad(pad: String) -> List(option.Option(String)) {
  string.to_graphemes(pad)
  |> list.map(fn(v) {
    case v {
      " " -> None
      ch -> Some(ch)
    }
  })
  |> list.filter(fn(v) {
    case v {
      Some("\n") -> False
      _ -> True
    }
  })
}

fn parse_move(value: String) -> Result(List(Move), Nil) {
  string.to_graphemes(value)
  |> list.map(fn(value) {
    case value {
      "U" -> Up
      "D" -> Down
      "L" -> Left
      "R" -> Right
      _ -> panic as { "unknown move '" <> value <> "'" }
    }
  })
  |> Ok()
}

fn execute_moves(acc: #(Int, List(Int)), moves: List(Move)) {
  let digit =
    list.fold(moves, acc.0, fn(acc, m) {
      case m {
        Up if acc != 1 && acc != 2 && acc != 3 -> acc - 3
        Down if acc != 7 && acc != 8 && acc != 9 -> acc + 3
        Left if acc != 1 && acc != 4 && acc != 7 -> acc - 1
        Right if acc != 3 && acc != 6 && acc != 9 -> acc + 1
        _ -> acc
      }
    })

  #(digit, [digit, ..acc.1])
}

fn part1(problem: Problem(String)) -> String {
  create_keypad(keypad_1) |> io.debug()

  let result =
    aoc.input_line_mapper(problem, parse_move)
    |> list.fold(#(5, []), execute_moves)

  list.reverse(result.1) |> list.map(int.to_string) |> string.join("")
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)

//   0
// }

pub fn main() {
  aoc.header(2016, 2)

  aoc.problem(aoc.Test, 2016, 2, 1) |> aoc.expect("1985") |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2016, 2, 1) |> aoc.expect("84452") |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2016, 2, 2) |> aoc.expect(0) |> aoc.run(part2)
}
