import gleeunit
import gleeunit/should
import support/grid/position.{Position}

pub fn main() {
  gleeunit.main()
}

pub fn difference_test() {
  position.difference(from: Position(1, 1), to: Position(2, 3))
  |> should.equal(#(1, 2))

  position.difference(from: Position(10, 12), to: Position(8, 9))
  |> should.equal(#(-2, -3))

  position.difference(from: Position(10, 9), to: Position(8, 12))
  |> should.equal(#(-2, 3))

  position.difference(from: Position(8, 12), to: Position(10, 9))
  |> should.equal(#(2, -3))
}
