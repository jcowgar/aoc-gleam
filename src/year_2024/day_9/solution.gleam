import aoc.{type Problem}
import gleam/int
import gleam/list.{Continue, Stop}

type Block {
  File(id: Int, size: Int)
  Space(size: Int)
}

type Disk {
  Disk(
    // Number of blocks total in the disk
    block_count: Int,
    // Blocks as they sit initially
    blocks: List(Int),
    // Blocks that are available to be used
    block_pool: List(Int),
    // Blocks represented by the type `Block`
    content: List(Block),
  )
}

fn parse_disk_map(problem: Problem(Int)) -> Disk {
  let #(blocks, content, size) =
    aoc.input_grapheme_mapper(problem, int.parse)
    |> list.index_fold(#([], [], 0), fn(acc, item, index) {
      case int.is_odd(index) {
        True -> #([list.repeat(-1, item), ..acc.0], [Space(item)], acc.2)
        False -> #(
          [list.repeat(index / 2, times: item), ..acc.0],
          [File(index / 2, item), ..acc.1],
          acc.2 + item,
        )
      }
    })

  let blocks = list.flatten(blocks)
  let block_pool = list.filter(blocks, fn(x) { x != -1 })

  Disk(
    size,
    blocks: blocks |> list.reverse(),
    block_pool: block_pool,
    content: content,
  )
}

fn part1(problem: Problem(Int)) -> Int {
  let disk = parse_disk_map(problem)

  let #(_, _, compacted) =
    disk.blocks
    |> list.fold_until(#(disk.block_count, disk, []), fn(acc, block) {
      case acc.0 {
        0 -> Stop(#(acc.0, acc.1, acc.2))
        _ -> {
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
        }
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

// fn part2(problem: Problem(Int)) -> Int {
//   let disk = parse_disk_map(problem)

//   0
// }

pub fn main() {
  aoc.header(2024, 9)

  aoc.sample(2024, 9, 1, 1) |> aoc.expect(1928) |> aoc.run(part1)
  aoc.problem(2024, 9, 1) |> aoc.expect(6_307_275_788_409) |> aoc.run(part1)
  // aoc.sample(2024, 9, 2, 1) |> aoc.expect(2858) |> aoc.run(part2)
  // aoc.problem(2024, 9, 2) |> aoc.expect(0) |> aoc.run(part2)
}
