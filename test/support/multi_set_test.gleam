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

pub fn pop_test() {
  let assert Ok(#(item, ms)) =
    multi_set.new()
    |> multi_set.add(1, 1)
    |> multi_set.add(1, 2)
    |> multi_set.pop(1)

  item |> should.equal(2)
  multi_set.keys(ms) |> should.equal([1])

  let assert Ok(#(item, ms)) = multi_set.pop(ms, 1)
  item |> should.equal(1)

  multi_set.keys(ms) |> should.equal([])

  let assert Error(_) = multi_set.pop(ms, 1)
  let assert Error(_) = multi_set.pop(ms, 2)
}
