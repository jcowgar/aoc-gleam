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

pub fn turn(current: Direction, direction: Turn) {
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
