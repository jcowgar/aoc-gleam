
import aoc.{type Problem}
import gleam/int

fn part1(problem: Problem(Int)) -> Int {
  let input = aoc.input_line_mapper(problem, int.parse)

  0
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   0
// }

pub fn main() {
	aoc.header(2024, 9)

  aoc.sample(2024, 9, 1, 1) |> aoc.expect(0) |> aoc.run(part1)
  // aoc.problem(2024, 9, 1) |> aoc.expect(0) |> aoc.run(part1)

  // aoc.sample(2024, 9, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
	// aoc.problem(2024, 9, 2) |> aoc.expect(0) |> aoc.run(part2)
}
