import gleam/list
import support/grid/direction.{type Direction, East, North, South, West}
import support/grid/position.{type Position, Position}

pub type Index =
  Int

pub type Grid {
  /// Create a new grid of `rows` and `columns`.
  Grid(rows: Int, columns: Int)
}

/// Compute the overall size of the grid. The size is the total number of
/// positions possible, or `rows * columns`.
///
pub fn size(g: Grid) -> Int {
  g.rows * g.columns
}

/// Check if the given `index` is a valid index in the grid.
/// The index is valid if it is greater than or equal to 0 and less than the
/// total size of the grid.
///
pub fn is_valid_index(g: Grid, index: Int) -> Bool {
  index >= 0 && index < size(g)
}

/// Check to see if `position` is a valid position in the grid.
///
pub fn is_valid_position(g: Grid, position: Position) -> Bool {
  position.x > 0
  && position.x <= g.columns
  && position.y > 0
  && position.y <= g.rows
}

/// Check if the two given `index1` and `index2` are in the same row.
///
pub fn is_same_row(g: Grid, index1: Int, index2: Int) -> Bool {
  index1 / g.columns == index2 / g.columns
}

fn row(g: Grid, index: Int) -> Int {
  index % g.columns + 1
}

fn column(g: Grid, index: Int) -> Int {
  index / g.columns + 1
}

/// Compute the position from the given `index`.
///
pub fn position_from_index(g: Grid, index: Int) -> Position {
  Position(row(g, index), column(g, index))
}

/// Compute the index from the given `position`.
///
pub fn position_to_index(g: Grid, position: Position) -> Index {
  { position.y - 1 } * g.columns + position.x - 1
}

/// Move from the given `location` in the given `direction` by the given `count`.
/// The result is the new location `index` after moving.
///
pub fn move(
  grid: Grid,
  location: Int,
  direction: Direction,
  count: Int,
) -> Result(Index, Nil) {
  let #(valid, new_location) = case direction {
    North -> #(True, location - { count * grid.columns })
    East -> {
      let new_location = location + count

      #(is_same_row(grid, location, new_location), new_location)
    }
    South -> #(True, location + { count * grid.columns })
    West -> {
      let new_location = location - count

      #(is_same_row(grid, location, new_location), new_location)
    }
  }

  case valid && is_valid_index(grid, new_location) {
    True -> Ok(new_location)
    False -> Error(Nil)
  }
}

/// Move from the given `location` in the given `direction` by the given `count`.
/// The result is the new location `index` after moving.
///
/// Wrapping will occur on all four sides of the grid. For example, if the
/// current location is at the top of the grid and you move North one space, the
/// new location will be on the bottom of the grid.
///
pub fn wrap_move(
  grid: Grid,
  location: Int,
  direction: Direction,
  count: Int,
) -> Index {
  case direction {
    North -> {
      let new_location = location - { count * grid.columns }

      case new_location < 0 {
        True -> new_location + grid.rows * grid.columns
        False -> new_location
      }
    }
    East -> {
      let new_location = location + count

      case is_same_row(grid, location, new_location) {
        True -> new_location
        False -> new_location - grid.columns
      }
    }
    South -> {
      let new_location = location + { count * grid.columns }

      case new_location >= size(grid) {
        True -> new_location - { grid.columns * grid.rows }
        False -> new_location
      }
    }
    West -> {
      let new_location = location - count

      case is_same_row(grid, location, new_location), new_location < 0 {
        True, False -> new_location
        _, _ -> new_location + grid.columns
      }
    }
  }
}

/// Compute the indexes that are touching the given `index` in the given `directions`.
///
pub fn touching_indexes(
  g: Grid,
  from index: Int,
  in_directions directions: List(Direction),
) -> List(Int) {
  directions
  |> list.map(fn(direction) { move(g, index, direction, 1) })
  |> list.map(fn(result) {
    case result {
      Ok(index) -> index
      Error(_) -> -1
    }
  })
}
