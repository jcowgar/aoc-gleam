import aoc.{type Problem}
import gleam/list
import gleam/otp/task
import gleam/set.{type Set}
import gleam/string
import glearray
import support/grid.{
  type Direction, type Grid, East, Grid, North, Right, South, West,
}

type Guard {
  Guard(location: Int, direction: Direction)
}

fn move(guard: Guard, grid: Grid) -> Result(Guard, Nil) {
  case grid.move(grid, guard.location, guard.direction, 1) {
    Ok(new_location) -> Ok(Guard(new_location, guard.direction))
    Error(_) -> Error(Nil)
  }
}

fn parse_data(content: String) -> #(Grid, Guard, glearray.Array(Int)) {
  let assert Ok(#(first_line, _)) = string.split_once(content, "\n")
  let grid_size = string.length(first_line)

  let #(_, guard, obstacle_list) =
    content
    |> string.replace("\n", "")
    |> string.to_graphemes()
    |> list.fold(#(0, Guard(0, North), []), fn(acc, value) {
      let #(object_type, new_guard) = case value {
        "#" -> #(1, acc.1)
        "^" -> #(2, Guard(acc.0, North))
        ">" -> #(2, Guard(acc.0, East))
        "v" -> #(2, Guard(acc.0, South))
        "<" -> #(2, Guard(acc.0, West))
        _ -> #(0, acc.1)
      }

      #(acc.0 + 1, new_guard, [object_type, ..acc.2])
    })

  #(
    Grid(grid_size, grid_size),
    guard,
    obstacle_list |> list.reverse() |> glearray.from_list(),
  )
}

fn find_visited(locations: Set(Int), grid, guard: Guard, obstacles) -> List(Int) {
  let new_visited_locations = set.insert(locations, guard.location)

  case move(guard, grid) {
    Ok(new_guard) -> {
      case glearray.get(obstacles, new_guard.location) {
        Ok(1) -> {
          let new_guard =
            Guard(guard.location, grid.turn(guard.direction, Right))
          find_visited(new_visited_locations, grid, new_guard, obstacles)
        }
        Ok(_) -> find_visited(new_visited_locations, grid, new_guard, obstacles)
        Error(_) -> panic as "tried to move to an invalid location"
      }
    }
    Error(_) -> set.to_list(new_visited_locations)
  }
}

fn part1(problem: Problem(Int)) -> Int {
  let #(grid, guard, obstacles) = parse_data(problem.input)

  find_visited(set.new(), grid, guard, obstacles)
  |> list.length()
}

fn does_loop(
  turn_count: Int,
  grid,
  guard: Guard,
  obstacles,
  temp_obstacle_idx,
) -> Int {
  case turn_count == grid.size(grid) {
    True -> 1
    False -> {
      case move(guard, grid) {
        Ok(new_guard) -> {
          let new_guard = case
            new_guard.location == temp_obstacle_idx,
            glearray.get(obstacles, new_guard.location)
          {
            True, _ -> Guard(guard.location, grid.turn(guard.direction, Right))
            _, Ok(1) -> Guard(guard.location, grid.turn(guard.direction, Right))
            _, Ok(_) -> new_guard
            _, Error(_) -> panic as "tried to move to an invalid location"
          }
          does_loop(
            turn_count + 1,
            grid,
            new_guard,
            obstacles,
            temp_obstacle_idx,
          )
        }
        Error(_) -> 0
      }
    }
  }
}

fn part2(problem: Problem(Int)) -> Int {
  let #(grid, guard, obstacles) = parse_data(problem.input)

  find_visited(set.new(), grid, guard, obstacles)
  |> list.fold(0, fn(acc, additional_obstacle_index) {
    does_loop(0, grid, guard, obstacles, additional_obstacle_index) + acc
  })
}

fn part2_using_tasks(problem: Problem(Int)) -> Int {
  let #(grid, guard, obstacles) = parse_data(problem.input)

  find_visited(set.new(), grid, guard, obstacles)
  |> list.map(fn(additional_obstacle_index) {
    task.async(fn() {
      does_loop(0, grid, guard, obstacles, additional_obstacle_index)
    })
  })
  |> task.try_await_all(1000)
  |> list.fold(0, fn(acc, result) {
    case result {
      Ok(value) -> value + acc
      Error(_) -> panic as "task failed"
    }
  })
}

pub fn main() {
  aoc.header(2024, 6)

  aoc.problem(aoc.Test, 2024, 6, 1) |> aoc.expect(41) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 6, 1) |> aoc.expect(4696) |> aoc.run(part1)
  aoc.problem(aoc.Test, 2024, 6, 1) |> aoc.expect(6) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2024, 6, 2) |> aoc.expect(1443) |> aoc.run(part2)
  aoc.problem(aoc.Actual, 2024, 6, 2)
  |> aoc.expect(1443)
  |> aoc.run(part2_using_tasks)
}
