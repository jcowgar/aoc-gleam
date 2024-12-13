import aoc.{type Problem}
import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set
import gleam/string

import support/grid.{type Grid, Grid}

type Bag(a) =
  Dict(a, List(a))

fn add_to_bag(b: Bag(Int), key: Int, value: Int) -> Bag(Int) {
  dict.upsert(b, key, fn(existing) {
    case existing {
      Some(values) -> [value, ..values]
      None -> [value]
    }
  })
}

fn parse_data(input: String) -> #(Grid, List(Int)) {
  let lines = string.split(input, "\n")
  let grid_size = list.first(lines) |> result.unwrap("") |> string.length()

  let grid =
    lines
    |> list.flat_map(fn(line) {
      string.to_utf_codepoints(line) |> list.map(string.utf_codepoint_to_int)
    })

  #(grid.Grid(grid_size, grid_size), grid)
}

pub fn list_to_sublists(input_list: List(a)) -> List(List(a)) {
  case input_list {
    [] -> []
    [_head, ..rest] -> [input_list, ..list_to_sublists(rest)]
  }
}

fn plot(s: set.Set(Int)) -> set.Set(Int) {
  list.range(0, 143)
  |> list.each(fn(index) {
    case index % 12 == 0 {
      True -> io.println("")
      False -> Nil
    }

    case set.contains(s, index) {
      True -> io.print("#")
      False -> io.print(".")
    }
  })

  io.println("")

  s
}

fn part1(problem: Problem(Int)) -> Int {
  let #(g, data) = problem.input |> string.trim() |> parse_data()

  let bag =
    list.index_fold(data, dict.new(), fn(acc, elem, index) {
      case elem {
        46 -> acc
        _ -> add_to_bag(acc, elem, index)
      }
    })

  list.fold(dict.keys(bag), set.new(), fn(acc, key) {
    // io.debug(#("key", key))

    let assert Ok(indexes) = dict.get(bag, key)
    let sub_list_indexes = list_to_sublists(indexes)
    // |> io.debug()

    list.fold(sub_list_indexes, acc, fn(acc, indexes) {
      let assert [head, ..rest] = indexes
      let head_row_col = grid.row_col_from_index(g, head)

      list.fold(rest, acc, fn(acc, sub_index) {
        let this_row_col = grid.row_col_from_index(g, sub_index)
        let #(row_diff, col_diff) =
          grid.row_col_diff(this_row_col, head_row_col)

        let antinode_up_right = #(
          head_row_col.0 - row_diff,
          head_row_col.1 - col_diff,
        )
        let antinode_down_left = #(
          this_row_col.0 + row_diff,
          this_row_col.1 + col_diff,
        )

        let antinode_up_right_index =
          grid.row_col_to_index(g, antinode_up_right.0, antinode_up_right.1)
        let antinode_down_left_index =
          grid.row_col_to_index(g, antinode_down_left.0, antinode_down_left.1)

        // io.debug(#(
        //   "indexes",
        //   indexes,
        //   "row_diff",
        //   row_diff,
        //   "col_diff",
        //   col_diff,
        //   "head row",
        //   head_row_col,
        //   "antinode up/right",
        //   antinode_up_right,
        //   "antinode down/left",
        //   antinode_down_left,
        // ))

        case
          grid.valid_index(g, antinode_up_right_index),
          grid.valid_index(g, antinode_down_left_index)
        {
          True, True ->
            acc
            |> set.insert(antinode_up_right_index)
            |> set.insert(antinode_down_left_index)
          True, False -> acc |> set.insert(antinode_up_right_index)
          False, True -> acc |> set.insert(antinode_down_left_index)
          False, False -> acc
        }
      })
    })
  })
  // |> plot()
  |> set.size()
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  grid.test_grid()

  aoc.header(2024, 8)

  aoc.problem(aoc.Test, 2024, 8, 1) |> aoc.expect(14) |> aoc.run(part1)
  // 439 too high
  aoc.problem(aoc.Actual, 2024, 8, 1) |> aoc.expect(0) |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2024, 8, 2) |> aoc.expect(0) |> aoc.run(part2)
}
