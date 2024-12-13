import gleeunit
import gleeunit/should
import support/grid
import support/grid/direction.{East, North, South, West}
import support/grid/position.{Position}

pub fn main() {
  gleeunit.main()
}

pub fn grid_size_test() {
  grid.Grid(3, 3) |> grid.size() |> should.equal(9)
}

pub fn grid_is_valid_index_test() {
  grid.Grid(3, 3) |> grid.is_valid_index(0) |> should.equal(True)
  grid.Grid(3, 3) |> grid.is_valid_index(8) |> should.equal(True)
  grid.Grid(3, 3) |> grid.is_valid_index(9) |> should.equal(False)
  grid.Grid(3, 3) |> grid.is_valid_index(-1) |> should.equal(False)
}

pub fn grid_is_same_row_test() {
  grid.Grid(3, 3) |> grid.is_same_row(0, 1) |> should.equal(True)
  grid.Grid(3, 3) |> grid.is_same_row(0, 3) |> should.equal(False)
}

pub fn position_from_index_test() {
  grid.Grid(3, 3) |> grid.position_from_index(0) |> should.equal(Position(1, 1))
  grid.Grid(3, 3) |> grid.position_from_index(1) |> should.equal(Position(2, 1))
  grid.Grid(3, 3) |> grid.position_from_index(2) |> should.equal(Position(3, 1))
  grid.Grid(3, 3) |> grid.position_from_index(3) |> should.equal(Position(1, 2))
  grid.Grid(3, 3) |> grid.position_from_index(4) |> should.equal(Position(2, 2))
  grid.Grid(3, 3) |> grid.position_from_index(5) |> should.equal(Position(3, 2))
  grid.Grid(3, 3) |> grid.position_from_index(6) |> should.equal(Position(1, 3))
  grid.Grid(3, 3) |> grid.position_from_index(7) |> should.equal(Position(2, 3))
  grid.Grid(3, 3) |> grid.position_from_index(8) |> should.equal(Position(3, 3))
}

pub fn position_to_index_test() {
  grid.Grid(3, 3) |> grid.position_to_index(Position(1, 1)) |> should.equal(0)
  grid.Grid(3, 3) |> grid.position_to_index(Position(2, 1)) |> should.equal(1)
  grid.Grid(3, 3) |> grid.position_to_index(Position(3, 1)) |> should.equal(2)
  grid.Grid(3, 3) |> grid.position_to_index(Position(1, 2)) |> should.equal(3)
  grid.Grid(3, 3) |> grid.position_to_index(Position(2, 2)) |> should.equal(4)
  grid.Grid(3, 3) |> grid.position_to_index(Position(3, 2)) |> should.equal(5)
  grid.Grid(3, 3) |> grid.position_to_index(Position(1, 3)) |> should.equal(6)
  grid.Grid(3, 3) |> grid.position_to_index(Position(2, 3)) |> should.equal(7)
  grid.Grid(3, 3) |> grid.position_to_index(Position(3, 3)) |> should.equal(8)
}

pub fn move_test() {
  let g = grid.Grid(3, 3)

  // Valid moves
  grid.move(g, 0, East, 1) |> should.equal(Ok(1))
  grid.move(g, 0, South, 1) |> should.equal(Ok(3))
  grid.move(g, 1, West, 1) |> should.equal(Ok(0))
  grid.move(g, 3, North, 1) |> should.equal(Ok(0))

  // Move off the grid
  grid.move(g, 0, West, 1) |> should.equal(Error(Nil))
  grid.move(g, 0, North, 1) |> should.equal(Error(Nil))
  grid.move(g, 8, East, 1) |> should.equal(Error(Nil))
  grid.move(g, 8, South, 1) |> should.equal(Error(Nil))

  grid.move(g, 0, South, 3) |> should.equal(Error(Nil))
  grid.move(g, 0, West, 3) |> should.equal(Error(Nil))
  grid.move(g, 8, West, 3) |> should.equal(Error(Nil))
  grid.move(g, 8, North, 3) |> should.equal(Error(Nil))
}
