pub type Direction {
  North
  East
  South
  West
}

pub type Turn {
  Right
  Left
}

/// Turn from `current` direction to the new direction.
pub fn turn(current: Direction, turn: Turn) {
  case current, turn {
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

/// Reverse the direction.
///
pub fn reverse(current: Direction) -> Direction {
  case current {
    North -> South
    East -> West
    South -> North
    West -> East
  }
}

pub type Grid {
  Grid(rows: Int, columns: Int)
}

pub fn size(g: Grid) -> Int {
  g.rows * g.columns
}

pub fn valid_index(g: Grid, index: Int) -> Bool {
  index >= 0 && index < size(g)
}

pub fn same_row(g: Grid, index1: Int, index2: Int) -> Bool {
  index1 / g.columns == index2 / g.columns
}

pub fn row_col_from_index(g: Grid, index: Int) -> #(Int, Int) {
  #(index / g.columns + 1, index % g.columns + 1)
}

pub fn row_col_diff(a: #(Int, Int), b: #(Int, Int)) -> #(Int, Int) {
  #(a.0 - b.0, a.1 - b.1)
}

pub fn row_col_to_index(g: Grid, row: Int, col: Int) -> Int {
  { row - 1 } * g.columns + col - 1
}

pub fn test_grid() {
  let g = Grid(3, 3)

  let assert #(1, 1) = row_col_from_index(g, 0)
  let assert #(1, 2) = row_col_from_index(g, 1)
  let assert #(1, 3) = row_col_from_index(g, 2)
  let assert #(2, 1) = row_col_from_index(g, 3)
  let assert #(2, 2) = row_col_from_index(g, 4)
  let assert #(2, 3) = row_col_from_index(g, 5)
  let assert #(3, 1) = row_col_from_index(g, 6)
  let assert #(3, 2) = row_col_from_index(g, 7)
  let assert #(3, 3) = row_col_from_index(g, 8)

  let assert 0 = row_col_to_index(g, 1, 1)
  let assert 1 = row_col_to_index(g, 1, 2)
  let assert 2 = row_col_to_index(g, 1, 3)
  let assert 3 = row_col_to_index(g, 2, 1)
  let assert 4 = row_col_to_index(g, 2, 2)
  let assert 5 = row_col_to_index(g, 2, 3)
  let assert 6 = row_col_to_index(g, 3, 1)
  let assert 7 = row_col_to_index(g, 3, 2)
  let assert 8 = row_col_to_index(g, 3, 3)
}

pub fn move(
  grid: Grid,
  location: Int,
  direction: Direction,
  count: Int,
) -> Result(Int, Nil) {
  let #(valid, new_location) = case direction {
    North -> #(True, location - { count * grid.columns })
    East -> {
      let new_location = location + count

      #(same_row(grid, location, new_location), new_location)
    }
    South -> #(True, location + { count * grid.columns })
    West -> {
      let new_location = location - 1

      #(same_row(grid, location, new_location), new_location)
    }
  }

  case valid && valid_index(grid, new_location) {
    True -> Ok(new_location)
    False -> Error(Nil)
  }
}
