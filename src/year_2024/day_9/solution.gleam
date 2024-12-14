import aoc.{type Problem}
import gleam/int
import gleam/io
import gleam/list
import gleam/result

type Block {
  File(id: Int, size: Int)
  Space(size: Int)
}

fn disk_map(problem: Problem(Int)) {
  aoc.input_grapheme_mapper(problem, int.parse)
  |> list.index_fold([], fn(acc, item, index) {
    case int.is_odd(index) {
      True -> [list.repeat(-1, item), ..acc]
      False -> [list.repeat(index / 2, times: item), ..acc]
    }
  })
  |> list.reverse()
  |> list.flatten()
}

fn disk_map_blocks(problem: Problem(Int)) {
  aoc.input_grapheme_mapper(problem, int.parse)
  |> list.index_fold([], fn(acc, item, index) {
    case int.is_odd(index) {
      True -> [Space(item), ..acc]
      False -> [File(index / 2, item), ..acc]
    }
  })
  |> list.reverse()
}

fn compact(disk_map, acc) {
  case disk_map {
    [] -> acc |> list.reverse()
    [-1, ..remaining_disk_map] -> {
      let tmp_disk_map = list.reverse(remaining_disk_map)

      case list.pop(tmp_disk_map, fn(x) { x != -1 }) {
        Error(_) -> compact(remaining_disk_map, [-1, ..acc])
        Ok(#(file_id, new_disk_map)) -> {
          compact(new_disk_map |> list.reverse(), [file_id, ..acc])
        }
      }
    }
    [file_id, ..remaining_disk_map] -> {
      compact(remaining_disk_map, [file_id, ..acc])
    }
  }
}

fn part1(problem: Problem(Int)) -> Int {
  disk_map(problem)
  |> compact([])
  |> list.index_fold(0, fn(acc, item, index) {
    case item {
      -1 -> acc
      file_id -> acc + { index * file_id }
    }
  })
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
  aoc.header(2024, 9)

  aoc.sample(2024, 9, 1, 1) |> aoc.expect(1928) |> aoc.run(part1)
  aoc.problem(2024, 9, 1) |> aoc.expect(6_307_275_788_409) |> aoc.run(part1)
  // aoc.sample(2024, 9, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
  // aoc.problem(2024, 9, 2) |> aoc.expect(0) |> aoc.run(part2)
}
