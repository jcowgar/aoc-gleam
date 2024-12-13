import aoc.{type Problem}
import gleam/list.{Continue, Stop}
import gleam/set
import gleam/string
import support/grid.{type Grid, Grid}
import support/grid/position.{type Position, Position}
import support/multi_set

fn parse_data(problem: Problem(Int)) -> #(Grid, List(Int)) {
  let lines = problem.input |> string.trim() |> string.split("\n")
  let #(row_count, column_count) = aoc.row_column_counts(lines)
  let grid =
    lines
    |> list.flat_map(fn(line) {
      string.to_utf_codepoints(line) |> list.map(string.utf_codepoint_to_int)
    })

  #(grid.Grid(row_count, column_count), grid)
}

fn solve(g: Grid, data, max_iterations: Int, position_fn) -> Int {
  let antennas =
    list.index_fold(data, multi_set.new(), fn(acc, elem, index) {
      case elem {
        46 -> acc
        _ -> multi_set.add(acc, elem, index)
      }
    })

  list.fold(multi_set.keys(antennas), set.new(), fn(acc, key) {
    let assert Ok(indexes) = multi_set.get(antennas, key)

    aoc.list_to_sublists(indexes)
    |> list.fold(acc, fn(acc, indexes) {
      let assert [head, ..rest] = indexes
      let head_xy = grid.position_from_index(g, head)

      list.fold(rest, acc, fn(acc, sub_index) {
        let this_xy = grid.position_from_index(g, sub_index)
        let #(x_diff, y_diff) = position.difference(this_xy, from: head_xy)

        list.range(1, max_iterations)
        |> list.fold_until(acc, fn(acc, mult) {
          let #(p1, p2) =
            position_fn(head_xy, this_xy, x_diff * mult, y_diff * mult)

          case grid.is_valid_position(g, p1), grid.is_valid_position(g, p2) {
            True, True -> acc |> set.insert(p1) |> set.insert(p2) |> Continue()
            True, False -> acc |> set.insert(p1) |> Continue()
            False, True -> acc |> set.insert(p2) |> Continue()
            False, False -> acc |> Stop()
          }
        })
      })
    })
  })
  |> set.size()
}

fn part1(problem: Problem(Int)) -> Int {
  let position_func = fn(head: Position, other: Position, x_diff, y_diff) {
    #(
      Position(head.x - x_diff, head.y - y_diff),
      Position(other.x + x_diff, other.y + y_diff),
    )
  }

  let #(g, data) = parse_data(problem)

  solve(g, data, 1, position_func)
}

fn part2(problem: Problem(Int)) -> Int {
  let position_func = fn(head: Position, other: Position, x_diff, y_diff) {
    #(
      Position(head.x + x_diff, head.y + y_diff),
      Position(other.x - x_diff, other.y - y_diff),
    )
  }
  let #(g, data) = parse_data(problem)

  solve(g, data, grid.size(g), position_func)
}

pub fn main() {
  aoc.header(2024, 8)

  aoc.sample(2024, 8, 1, 1) |> aoc.expect(14) |> aoc.run(part1)
  aoc.problem(2024, 8, 1) |> aoc.expect(364) |> aoc.run(part1)

  aoc.sample(2024, 8, 2, 1) |> aoc.expect(34) |> aoc.run(part2)
  aoc.problem(2024, 8, 2) |> aoc.expect(1231) |> aoc.run(part2)
}
