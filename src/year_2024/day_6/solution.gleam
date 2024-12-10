import aoc.{type Problem}
import atomic_array as aa
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string

type Direction {
  North
  East
  South
  West
}

type Turn {
  Right
  Left
}

fn turn(current: Direction, direction: Turn) {
  case current, direction {
    North, Right -> East
    North, Left -> West
    East, Right -> South
    East, Left -> North
    South, Right -> West
    South, Left -> East
    West, Right -> North
    West, Left -> South
  }
}

type Guard {
  Guard(location: Int, direction: Direction)
}

fn move(guard: Guard, grid: Grid) -> Result(Guard, Nil) {
  let #(_, old_row) = grid_row_column_from_index(grid, guard.location)

  let #(valid, new_guard) = case guard {
    Guard(location, North) -> {
      let new_index = location - grid.columns

      #(new_index >= 0, Guard(new_index, guard.direction))
    }

    Guard(location, East) -> {
      let #(_, new_row) = grid_row_column_from_index(grid, location)

      #(old_row == new_row, Guard(location + 1, guard.direction))
    }

    Guard(location, South) -> {
      let new_index = location + grid.columns

      #(new_index < grid_size(grid), Guard(new_index, guard.direction))
    }

    Guard(location, West) -> {
      let #(_, new_row) = grid_row_column_from_index(grid, location)

      #(old_row == new_row, Guard(location - 1, guard.direction))
    }
  }

  case valid {
    True -> Ok(new_guard)
    False -> Error(Nil)
  }
}

type Grid {
  Grid(rows: Int, columns: Int)
}

fn grid_size(g: Grid) -> Int {
  g.rows * g.columns
}

fn grid_index(g: Grid, row: Int, column: Int) -> Int {
  row * g.columns + column
}

fn grid_row_column_from_index(g: Grid, index: Int) -> #(Int, Int) {
  #(index / g.columns, index % g.columns)
}

fn parse_data(content: String) -> #(Grid, Guard, aa.AtomicArray) {
  let assert Ok(#(first_line, _)) = string.split_once(content, "\n")
  let grid_size = string.length(first_line)
  let obstacles = aa.new_unsigned(grid_size * grid_size)

  let #(_, guard) =
    content
    |> string.replace("\n", "")
    |> string.to_graphemes()
    |> list.fold(#(0, Guard(0, North)), fn(acc, value) {
      case value {
        "#" -> {
          let _ = aa.set(obstacles, acc.0, 1)
          #(acc.0 + 1, acc.1)
        }
        "^" -> {
          let _ = aa.set(obstacles, acc.0, 2)

          #(acc.0 + 1, Guard(acc.0, North))
        }
        ">" -> {
          let _ = aa.set(obstacles, acc.0, 2)

          #(acc.0 + 1, Guard(acc.0, East))
        }
        "v" -> {
          let _ = aa.set(obstacles, acc.0, 2)

          #(acc.0 + 1, Guard(acc.0, South))
        }
        "<" -> {
          let _ = aa.set(obstacles, acc.0, 2)

          #(acc.0 + 1, Guard(acc.0, West))
        }
        _ -> #(acc.0 + 1, acc.1)
      }
    })

  #(Grid(grid_size, grid_size), guard, obstacles)
}

fn solve(visited_locations: Set(Int), grid, guard: Guard, obstacles) -> Int {
  let new_visited_locations = set.insert(visited_locations, guard.location)

  case move(guard, grid) {
    Ok(new_guard) -> {
      case aa.get(obstacles, new_guard.location) {
        Ok(1) -> {
          let new_guard = Guard(guard.location, turn(guard.direction, Right))
          solve(new_visited_locations, grid, new_guard, obstacles)
        }
        Ok(_) -> solve(new_visited_locations, grid, new_guard, obstacles)
        Error(_) -> panic as "tried to move to an invalid location"
      }
    }
    Error(_) -> set.size(new_visited_locations)
  }
}

fn part1(problem: Problem(Int)) -> Int {
  let #(grid, guard, obstacles) = parse_data(problem.input)

  solve(set.new(), grid, guard, obstacles)
}

fn part2(problem: Problem(Int)) -> Int {
  let #(grid, guard, obstacles) = parse_data(problem.input)

  0
}

pub fn main() {
  aoc.header(2024, 6)

  aoc.problem(aoc.Test, 2024, 6, 1) |> aoc.expect(41) |> aoc.run(part1)
  aoc.problem(aoc.Actual, 2024, 6, 1) |> aoc.expect(4696) |> aoc.run(part1)
  // aoc.problem(aoc.Test, 2024, 6, 1) |> aoc.expect(6) |> aoc.run(part2)
  // aoc.problem(aoc.Actual, 2024, 6, 2) |> aoc.expect(0) |> aoc.run(part2)
}
