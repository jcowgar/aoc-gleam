import aoc.{type Problem}
import gleam/io
import gleam/option.{Some}
import gleam/regexp
import support/grid/position.{type Position, Position}

type Robot {
  Robot(position: Position, velocity: Position)
}

fn parse_line(line: String) -> Result(Robot, Nil) {
  let assert Ok(re) =
    regexp.from_string("p=(-?\\d+),(-?\\d+) v=(-?\\d+),(-?\\d+)")

  let assert [regexp.Match(_, [Some(px), Some(py), Some(vx), Some(vy)])] =
    regexp.scan(re, line)

  Ok(Robot(
    Position(aoc.int(px), aoc.int(py)),
    Position(aoc.int(vx), aoc.int(vy)),
  ))
}

fn parse_data(problem: Problem(Int)) -> List(Robot) {
  aoc.input_line_mapper(problem, parse_line)
}

// Where will the robots be after 100 seconds?
// Divide board into 4 quadrants
// Count the number of robots in each quadrant
// Sum the result of the 4 quadrants
// This is the safety factor and my answer
//
// Robots exactly in the center (vertical or horizontal) line are omitted from
// any quadrant
fn part1(problem: Problem(Int)) -> Int {
  parse_data(problem) |> io.debug()

  -1
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   -1
// }

pub fn main() {
  aoc.header(2024, 14)

  aoc.sample(2024, 14, 1, 1) |> aoc.expect(12) |> aoc.run(part1)
  // aoc.problem(2024, 14, 1) |> aoc.expect(0) |> aoc.run(part1)

  // aoc.sample(2024, 14, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
  // aoc.problem(2024, 14, 2) |> aoc.expect(0) |> aoc.run(part2)
}
//
// - 12 robots in sample, 500 robots in real
// - Robots move in straight lines
// - grid is *not* a square, 11x7 in sample, 101x103 in real
// - robots can share the same tile
// - when robots hit edge, they teleport to the other side
// - p = 0,0 is top left corner
// - v = 1,1 is down and right moves per second
// - v = -1,-1 is up and left moves per second
