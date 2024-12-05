import aoc.{type Problem}
import gleam/list
import gleam/pair

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

fn deliver(directions) {
  directions
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
  |> pair.second()
}

fn part1(problem: Problem(Int)) -> Int {
  aoc.input_grapheme_mapper(problem, char_to_direction)
  |> deliver()
  |> list.unique()
  |> list.length()
}

fn part2(problem: Problem(Int)) -> Int {
  let #(santa_directions, robot_directions) =
    aoc.input_grapheme_mapper(problem, char_to_direction)
    |> list.index_fold(#([], []), fn(acc, dir, index) {
      case index % 2 == 0 {
        True -> #([dir, ..acc.0], acc.1)
        False -> #(acc.0, [dir, ..acc.1])
      }
    })

  let santa_houses = deliver(santa_directions)
  let robot_houses = deliver(robot_directions)

  list.flatten([santa_houses, robot_houses]) |> list.unique() |> list.length()
}

pub fn main() {
  aoc.header(2015, 3)

  aoc.problem(aoc.Test, 2015, 3, 1) |> aoc.expect(5) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2015, 3, 1) |> aoc.expect(2565) |> aoc.run(part1)

  // 2752 is too high
  aoc.problem(aoc.Test, 2015, 3, 2) |> aoc.expect(11) |> aoc.run(part2)
  aoc.problem(aoc.Test, 2015, 3, 3) |> aoc.expect(3) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2015, 3, 2) |> aoc.expect(0) |> aoc.run(part2)
}
