import aoc.{type Problem}
import atomic_array as aa
import gleam/bool
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/result

type Disk {
  Disk(
    // Number of blocks total in the disk
    block_count: Int,
    // Blocks as they sit initially
    blocks: List(Int),
    // Blocks that are available to be used
    block_pool: List(Int),
  )
}

/// Move in `blocks` to index `to` from index `from` for `count` blocks.
///
fn move_block(
  in blocks: aa.AtomicArray,
  to to: Int,
  from from: Int,
  count count: Int,
) -> Nil {
  let assert Ok(block) = aa.get(blocks, from)

  list.range(0, count - 1)
  |> list.each(fn(index) {
    let _ = aa.set(blocks, to + index, block)
    let _ = aa.set(blocks, from + index, -1)
  })
}

/// Returns start index and size
///
fn find_last_file(
  in blocks: aa.AtomicArray,
  start_at start_scan_index: Int,
) -> #(Int, Int) {
  list.range(start_scan_index, 0)
  |> list.fold_until(#(-1, -1), fn(_acc, tail_index) {
    // Look for tail block
    case aa.get(blocks, tail_index) {
      Error(_) -> panic as "invalid block index"
      Ok(-1) -> Continue(#(-1, -1))
      Ok(tail_block) -> {
        let #(head_index, tail_index) =
          list.range(tail_index - 1, 0)
          |> list.fold_until(#(tail_index, tail_index), fn(_acc, head_index) {
            case aa.get(blocks, head_index) {
              Ok(-1) -> Stop(#(head_index + 1, tail_index))
              Ok(this_block) if this_block != tail_block ->
                Stop(#(head_index + 1, tail_index))
              Ok(_) -> Continue(#(-1, -1))
              Error(_) ->
                panic as "invalid block index while scanning for head_index"
            }
          })

        case head_index, tail_index {
          -1, _ | _, -1 -> Stop(#(-1, -1))
          head_index, tail_index ->
            Stop(#(head_index, tail_index - head_index + 1))
        }
      }
    }
  })
}

fn parse_disk_map(problem: Problem(Int)) -> Disk {
  let #(blocks, size) =
    aoc.input_grapheme_mapper(problem, int.parse)
    |> list.index_fold(#([], 0), fn(acc, item, index) {
      case int.is_odd(index) {
        True -> #([list.repeat(-1, item), ..acc.0], acc.1)
        False -> #([list.repeat(index / 2, times: item), ..acc.0], acc.1 + item)
      }
    })

  let blocks = list.flatten(blocks)
  let block_pool = list.filter(blocks, fn(x) { x != -1 })

  Disk(size, blocks: blocks |> list.reverse(), block_pool: block_pool)
}

fn part1(problem: Problem(Int)) -> Int {
  let disk = parse_disk_map(problem)

  let #(_, _, compacted) =
    disk.blocks
    |> list.fold_until(#(disk.block_count, disk, []), fn(acc, block) {
      use <- bool.guard(acc.0 == 0, Stop(#(acc.0, acc.1, acc.2)))

      case block {
        -1 -> {
          // grab a block from the block pool
          let assert [pooled_block, ..block_pool] = { acc.1 }.block_pool

          Continue(
            #(acc.0 - 1, Disk(..acc.1, block_pool: block_pool), [
              pooled_block,
              ..acc.2
            ]),
          )
        }
        _ -> Continue(#(acc.0 - 1, acc.1, [block, ..acc.2]))
      }
    })

  compacted
  |> list.reverse()
  |> list.index_fold(0, fn(acc, item, index) {
    case item {
      -1 -> acc
      file_id -> acc + { index * file_id }
    }
  })
}

fn test_move_block() {
  let blocks = aa.new_signed(9)
  let _ = aa.set(blocks, 0, 0)
  let _ = aa.set(blocks, 1, 0)
  let _ = aa.set(blocks, 2, -1)
  let _ = aa.set(blocks, 3, -1)
  let _ = aa.set(blocks, 4, -1)
  let _ = aa.set(blocks, 5, 1)
  let _ = aa.set(blocks, 6, 1)
  let _ = aa.set(blocks, 7, 1)
  let _ = aa.set(blocks, 8, -1)

  let assert #(5, 3) = find_last_file(blocks, 8)

  move_block(in: blocks, to: 2, from: 5, count: 3)

  let assert [0, 0, 1, 1, 1, -1, -1, -1, -1] = aa.to_list(blocks)
}

fn find_space(
  in blocks: aa.AtomicArray,
  start start_scan_index: Int,
  size_needed needed: Int,
) -> Result(#(Int, Int), Nil) {
  let found =
    list.range(start_scan_index, aa.size(blocks) - 1)
    |> list.fold_until(#(-1, -1), fn(acc, index) {
      case aa.get(blocks, index) {
        Ok(-1) -> {
          let first_space = case acc.1 {
            -1 -> index
            _ -> acc.1
          }

          let chunk =
            list.range(index, index + needed - 1)
            |> list.fold([], fn(acc, i) {
              [aa.get(blocks, i) |> result.unwrap(0), ..acc]
            })

          case chunk == list.repeat(-1, times: needed) {
            True -> Stop(#(index, first_space))
            False -> Continue(#(-1, first_space))
          }
        }
        Ok(_) -> Continue(acc)
        Error(_) -> panic as "invalid block index"
      }
    })

  case found.0, found.1 {
    -1, _ -> Error(Nil)
    index, first_space -> Ok(#(index, first_space))
  }
}

fn part2(problem: Problem(Int)) -> Int {
  test_move_block()

  let disk = parse_disk_map(problem)
  let block_count = list.length(disk.blocks)
  let blocks = aa.new_signed(block_count)
  list.index_fold(disk.blocks, 0, fn(_acc, block, index) {
    let _ = aa.set(blocks, index, block)

    0
  })

  disk.blocks
  |> list.fold_until(#(block_count - 1, 0), fn(acc, _block) {
    use <- bool.guard(acc.0 <= 0, Stop(acc))

    let assert Ok(block) = aa.get(blocks, acc.0)

    case block {
      -1 -> Continue(#(acc.0 - 1, acc.1))
      _ -> {
        let #(start_index, size) = find_last_file(in: blocks, start_at: acc.0)

        case find_space(in: blocks, start: acc.1, size_needed: size) {
          Error(_) -> Continue(#(start_index - 1, acc.1))
          Ok(#(space_index, first_space)) if space_index < start_index -> {
            move_block(
              in: blocks,
              to: space_index,
              from: start_index,
              count: size,
            )

            Continue(#(start_index - 1, first_space))
          }
          Ok(_) -> Continue(#(start_index - 1, acc.1))
        }
      }
    }
  })

  aa.to_list(blocks)
  |> list.index_fold(0, fn(acc, item, index) {
    case item {
      -1 -> acc
      file_id -> acc + { index * file_id }
    }
  })
}

pub fn main() {
  aoc.header(2024, 9)

  aoc.sample(2024, 9, 1, 1) |> aoc.expect(1928) |> aoc.run(part1)
  aoc.problem(2024, 9, 1) |> aoc.expect(6_307_275_788_409) |> aoc.run(part1)
  aoc.sample(2024, 9, 2, 1) |> aoc.expect(2858) |> aoc.run(part2)
  aoc.problem(2024, 9, 2) |> aoc.expect(6_327_174_563_252) |> aoc.run(part2)
}
