import gleeunit
import gleeunit/should
import support/multi_set

pub fn main() {
  gleeunit.main()
}

pub fn add_get_test() {
  multi_set.new()
  |> multi_set.add(1, 2)
  |> multi_set.get(1)
  |> should.equal(Ok([2]))
}

pub fn keys_test() {
  multi_set.new()
  |> multi_set.add(1, 1)
  |> multi_set.add(2, 2)
  |> multi_set.keys()
  |> should.equal([1, 2])
}

pub fn add_multiple_test() {
  multi_set.new()
  |> multi_set.add(1, 1)
  |> multi_set.add(1, 2)
  |> multi_set.get(1)
  |> should.equal(Ok([2, 1]))
}

pub fn delete_test() {
  multi_set.new()
  |> multi_set.add(1, 1)
  |> multi_set.delete(1)
  |> multi_set.get(1)
  |> should.equal(Error(Nil))
}
