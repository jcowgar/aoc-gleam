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
  let nums = list.range(0, 3)
  let start_column = start_position % width
  let start_row = { start_position - start_column } / height

  let can_go_right = start_column + 3 < width
  let can_go_left = start_column - 3 >= 0
  let can_go_down = start_row + 3 < height
  let can_go_up = start_row - 3 >= 0

  // io.debug(#(
  //   "sp",
  //   start_position,
  //   "sr",
  //   start_row,
  //   "sc",
  //   start_column,
  //   "cgl",
  //   can_go_left,
  //   "cgr",
  //   can_go_right,
  //   "cgd",
  //   can_go_down,
  //   "cgu",
  //   can_go_up,
  // ))

  [
    // from start -> right
    check(can_go_right, list.map(nums, fn(n) { start_position + n })),
    // from start -> left
    check(can_go_left, list.map(nums, fn(n) { start_position - n })),
    // from start -> down
    check(can_go_down, list.map(nums, fn(n) { start_position + { n * width } })),
    // from start -> up
    check(can_go_up, list.map(nums, fn(n) { start_position - { n * width } })),
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
    // from start -> up and right
    check(
      can_go_up && can_go_right,
      list.map(nums, fn(n) { start_position - { n * { width - 1 } } }),
    ),
    // from start -> up and left
    check(
      can_go_up && can_go_left,
      list.map(nums, fn(n) { start_position - { n * { width + 1 } } }),
    ),
  ]
  |> list.filter(fn(l) { l != [] })
}

fn part1(problem: Problem(Int)) -> Int {
  let data = parse_input(problem.input)
  let d = data.3

  list.range(0, { data.0 * data.1 } - 1)
  |> list.map(fn(start_index) {
    compute_positions(start_index, data.0, data.1)
    |> list.count(fn(p) {
      let assert [xi, mi, ai, si] = p

      dict.get(d, xi) == Ok("X")
      && dict.get(d, mi) == Ok("M")
      && dict.get(d, ai) == Ok("A")
      && dict.get(d, si) == Ok("S")
    })
  })
  |> int.sum()
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  aoc.header(2024, 4)

  aoc.problem(aoc.Test, 2024, 4, 0) |> aoc.expect(3) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2024, 4, 1) |> aoc.expect(18) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 4, 1) |> aoc.expect(2358) |> aoc.run(part1)
  // aoc.problem(aoc.Actual, 2024, 4, 2) |> aoc.expect(0) |> aoc.run(part2)
}
