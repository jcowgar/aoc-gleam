import aoc.{type Problem}
import atomic_array as aa
import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import support/grid
import support/grid/direction.{East, North, South, West}

type Island {
  Island(topographical_map: aa.AtomicArray, trailheads: List(Int), g: grid.Grid)
}

fn parse_data(input: String) -> Island {
  let lines = string.split(input, "\n")
  let width = string.length(list.first(lines) |> result.unwrap(""))
  let height = list.length(lines)
  let points = aa.new_unsigned(width * height)
  let #(_, trailheads) =
    string.replace(input, "\n", "")
    |> string.to_graphemes()
    |> list.fold(#(0, []), fn(acc, point) {
      let _ = aa.set(points, acc.0, point |> aoc.int())
      let trailheads = case point {
        "0" -> [acc.0, ..acc.1]
        _ -> acc.1
      }

      #(acc.0 + 1, trailheads)
    })

  Island(points, trailheads |> list.reverse(), grid.Grid(height, width))
}

fn find_path(acc, path: List(Int), this_index: Int, island: Island) {
  let assert Ok(head) = aa.get(island.topographical_map, this_index)

  [North, East, South, West]
  |> list.fold(acc, fn(acc, direction) {
    let next_index = grid.move(island.g, this_index, direction, 1)

    case next_index {
      Ok(next_index) -> {
        let assert Ok(next) = aa.get(island.topographical_map, next_index)

        case next {
          9 if head == 8 -> [[next_index, ..path], ..acc]
          _ if next == head + 1 ->
            find_path(acc, [next_index, ..path], next_index, island)
          _ -> acc
        }
      }
      Error(_) -> acc
    }
  })
}

//  0 - 89010123
//  8 - 78121874
// 16 - 87430965
// 24 - 96549874
// 32 - 45678903
// 40 - 32019012
// 48 - 01329801
// 56 - 10456732

fn part1(problem: Problem(Int)) -> Int {
  let island = parse_data(problem.input)

  island.trailheads
  |> list.map(fn(trailhead) {
    #(
      trailhead,
      find_path([], [trailhead], trailhead, island)
        |> list.map(fn(path) { list.first(path) |> result.unwrap(0) })
        |> list.unique(),
    )
  })
  |> list.map(fn(scoring) { list.length(scoring.1) })
  |> int.sum()
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   -1
// }

pub fn main() {
  aoc.header(2024, 10)

  aoc.sample(2024, 10, 1, 1) |> aoc.expect(36) |> aoc.run(part1)
  aoc.problem(2024, 10, 1) |> aoc.expect(552) |> aoc.run(part1)
  // aoc.sample(2024, 10, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
  // aoc.problem(2024, 10, 2) |> aoc.expect(0) |> aoc.run(part2)
}
