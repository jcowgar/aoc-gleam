import aoc.{type Problem}
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse_input(input: String) {
  // -> #(Int, Int, List(String), Dict(Int, String)) {
  let lines = string.split(input, "\n")

  let width = string.length(list.first(lines) |> result.unwrap(""))
  let height = list.length(lines)

  let characters =
    input |> string.to_graphemes() |> list.filter(fn(v) { v != "\n" })

  #(
    width,
    height,
    characters,
    list.index_map(characters, fn(v, i) { #(i, v) }) |> dict.from_list(),
  )
}

fn what_directions_can_i_go(
  start_position,
  count,
  width,
  height,
) -> #(Bool, Bool, Bool, Bool) {
  let start_column = start_position % width
  let start_row = { start_position - start_column } / height

  let can_go_right = start_column + count < width
  let can_go_left = start_column - count >= 0
  let can_go_down = start_row + count < height
  let can_go_up = start_row - count >= 0

  #(can_go_right, can_go_down, can_go_left, can_go_up)
}

fn check(condition, list) {
  case condition {
    True -> list
    False -> []
  }
}

fn compute_positions(
  start_position: Int,
  width: Int,
  height: Int,
) -> List(List(Int)) {
  let #(can_go_right, can_go_down, can_go_left, _can_go_up) =
    what_directions_can_i_go(start_position, 3, width, height)
  let nums = list.range(0, 3)

  [
    // from start -> right
    check(can_go_right, list.map(nums, fn(n) { start_position + n })),
    // from start -> down
    check(can_go_down, list.map(nums, fn(n) { start_position + { n * width } })),
    // from start -> down and right
    check(
      can_go_down && can_go_right,
      list.map(nums, fn(n) { start_position + { n * { width + 1 } } }),
    ),
    // from start -> down and left
    check(
      can_go_down && can_go_left,
      list.map(nums, fn(n) { start_position + { n * { width - 1 } } }),
    ),
  ]
  |> list.filter(fn(l) { l != [] })
}

fn get_word(d, indexes) -> String {
  list.map(indexes, fn(idx) { dict.get(d, idx) |> result.unwrap("") })
  |> string.join("")
}

fn part1(problem: Problem(Int)) -> Int {
  let data = parse_input(problem.input)
  let d = data.3

  list.range(0, { data.0 * data.1 } - 1)
  |> list.map(fn(start_index) {
    compute_positions(start_index, data.0, data.1)
    |> list.count(fn(p) {
      let word = get_word(d, p)
      word == "XMAS" || word == "SAMX"
    })
  })
  |> int.sum()
}

fn compute_x_positions(
  start_position: Int,
  width: Int,
  height: Int,
) -> List(List(Int)) {
  let #(can_go_right, can_go_down, can_go_left, can_go_up) =
    what_directions_can_i_go(start_position, 1, width, height)

  case can_go_up && can_go_down && can_go_right && can_go_left {
    True -> [
      [start_position - width - 1, start_position, start_position + width + 1],
      [start_position - width + 1, start_position, start_position + width - 1],
    ]
    False -> []
  }
}

fn part2(problem: Problem(Int)) -> Int {
  let is_mas = fn(v) { v == "MAS" || v == "SAM" }
  let data = parse_input(problem.input)
  let d = data.3

  list.range(0, { data.0 * data.1 } - 1)
  |> list.count(fn(start_index) {
    case compute_x_positions(start_index, data.0, data.1) {
      [a, b] -> is_mas(get_word(d, a)) && is_mas(get_word(d, b))
      _ -> False
    }
  })
}

pub fn main() {
  aoc.header(2024, 4)

  aoc.problem(aoc.Test, 2024, 4, 0) |> aoc.expect(3) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2024, 4, 1) |> aoc.expect(18) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 4, 1) |> aoc.expect(2358) |> aoc.run(part1)

  aoc.problem(aoc.Test, 2024, 4, 1) |> aoc.expect(9) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2024, 4, 2) |> aoc.expect(1737) |> aoc.run(part2)
}
