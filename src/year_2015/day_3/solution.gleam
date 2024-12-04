import aoc.{type Problem}
import gleam/list

type Direction {
  North
  East
  South
  West
}

type House {
  House(x: Int, y: Int)
}

fn char_to_direction(ch: String) -> Result(Direction, Nil) {
  case ch {
    "^" -> North
    ">" -> East
    "v" -> South
    "<" -> West
    _ -> panic as { "unknown direction '" <> ch <> "'" }
  }
  |> Ok()
}

fn part1(problem: Problem(Int)) -> Int {
  let #(_, houses) =
    aoc.input_grapheme_mapper(problem, char_to_direction)
    |> list.fold(#(House(0, 0), [House(0, 0)]), fn(acc, direction) {
      case direction {
        North -> {
          let new_house = House({ acc.0 }.x, { acc.0 }.y - 1)
          #(new_house, [new_house, ..acc.1])
        }
        East -> {
          let new_house = House({ acc.0 }.x + 1, { acc.0 }.y)
          #(new_house, [new_house, ..acc.1])
        }
        South -> {
          let new_house = House({ acc.0 }.x, { acc.0 }.y + 1)
          #(new_house, [new_house, ..acc.1])
        }
        West -> {
          let new_house = House({ acc.0 }.x - 1, { acc.0 }.y)
          #(new_house, [new_house, ..acc.1])
        }
      }
    })

  list.unique(houses)
  |> list.length()
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  aoc.header(2015, 3)

  aoc.problem(aoc.Test, 2015, 3, 1) |> aoc.expect(5) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2015, 3, 1) |> aoc.expect(2565) |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2015, 3, 2) |> aoc.expect(0) |> aoc.run(part2)
}
