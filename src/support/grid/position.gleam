pub type Position {
  /// Store X and Y positions.
  ///
  Position(x: Int, y: Int)
}

/// Compute the difference between two positions. The result is a tuple of the
/// differences in the x and y coordinates.
///
/// # Examples
///
/// ```
/// import support/grid/position
///
/// let a = position.Position(1, 1)
/// let b = position.Position(2, 3)
///
/// position.difference(from: a, to: b) // #(1, 2)
/// ```
///
pub fn difference(from a: Position, to b: Position) -> #(Int, Int) {
  #(b.x - a.x, b.y - a.y)
}
