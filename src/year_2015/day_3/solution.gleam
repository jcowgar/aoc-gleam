import aoc.{type Problem}
import gleam/int
import gleam/list
import gleam/pair
import gleam/set

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

fn deliver(s, directions) {
  directions
  |> list.fold(#(House(0, 0), s), fn(acc, direction) {
    let new_house = case direction {
      North -> House({ acc.0 }.x, { acc.0 }.y - 1)
      East -> House({ acc.0 }.x + 1, { acc.0 }.y)
      South -> House({ acc.0 }.x, { acc.0 }.y + 1)
      West -> House({ acc.0 }.x - 1, { acc.0 }.y)
    }

    #(new_house, set.insert(acc.1, new_house))
  })
  |> pair.second()
}

fn part1(problem: Problem(Int)) -> Int {
  let directions = aoc.input_grapheme_mapper(problem, char_to_direction)

  deliver(set.from_list([House(0, 0)]), directions)
  |> set.size()
}

fn part2(problem: Problem(Int)) -> Int {
  let #(santa_directions, robot_directions) =
    aoc.input_grapheme_mapper(problem, char_to_direction)
    // reverse direction list because index_fold is appending at head
    |> list.reverse()
    |> list.index_fold(#([], []), fn(acc, dir, index) {
      case int.is_odd(index) {
        True -> #([dir, ..acc.0], acc.1)
        False -> #(acc.0, [dir, ..acc.1])
      }
    })

  set.from_list([House(0, 0)])
  |> deliver(santa_directions)
  |> deliver(robot_directions)
  |> set.size()
}

pub fn main() {
  aoc.header(2015, 3)

  aoc.problem(aoc.Test, 2015, 3, 1) |> aoc.expect(5) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2015, 3, 1) |> aoc.expect(2565) |> aoc.run(part1)

  aoc.problem(aoc.Test, 2015, 3, 2) |> aoc.expect(11) |> aoc.run(part2)
  aoc.problem(aoc.Test, 2015, 3, 3) |> aoc.expect(3) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2015, 3, 2) |> aoc.expect(2639) |> aoc.run(part2)
}
