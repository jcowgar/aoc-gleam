import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}

pub type MultiSet(a, b) =
  Dict(a, List(b))

pub fn new() -> MultiSet(a, b) {
  dict.new()
}

pub fn add(b: MultiSet(a, b), key: a, value: b) -> MultiSet(a, b) {
  dict.upsert(b, key, fn(existing) {
    case existing {
      Some(values) -> [value, ..values]
      None -> [value]
    }
  })
}

pub fn keys(b: MultiSet(a, b)) -> List(a) {
  dict.keys(b)
}

pub fn get(b: MultiSet(a, b), key: a) -> Result(List(b), Nil) {
  dict.get(b, key)
}
