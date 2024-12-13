import gleeunit
import gleeunit/should
import support/grid/direction.{East, North, South, West}
import support/grid/turn.{Around, Left, Right}

pub fn main() {
  gleeunit.main()
}

pub fn to_test() {
  turn.to(Right, from: East) |> should.equal(South)
  turn.to(Left, from: East) |> should.equal(North)
  turn.to(Around, from: East) |> should.equal(West)
  turn.to(Right, from: North) |> should.equal(East)
  turn.to(Left, from: North) |> should.equal(West)
  turn.to(Around, from: North) |> should.equal(South)
  turn.to(Right, from: South) |> should.equal(West)
  turn.to(Left, from: South) |> should.equal(East)
  turn.to(Around, from: South) |> should.equal(North)
  turn.to(Right, from: West) |> should.equal(North)
  turn.to(Left, from: West) |> should.equal(South)
  turn.to(Around, from: West) |> should.equal(East)
}
