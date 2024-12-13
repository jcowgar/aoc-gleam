import support/grid/direction.{type Direction, East, North, South, West}

/// Turn various directions.
///
pub type Turn {
  Right
  Left
  Around
}

/// Turn to the `turn: Turn` from the given `from: Direction`.
///
pub fn to(turn: Turn, from current: Direction) {
  case current, turn {
    East, Around -> West
    East, Left -> North
    East, Right -> South
    North, Around -> South
    North, Left -> West
    North, Right -> East
    South, Around -> North
    South, Left -> East
    South, Right -> West
    West, Around -> East
    West, Left -> South
    West, Right -> North
  }
}
