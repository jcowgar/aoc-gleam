import gleam/dict.{type Dict}
import gleam/option.{None, Some}

pub type MultiSet(a, b) =
  Dict(a, List(b))

pub fn new() -> MultiSet(a, b) {
  dict.new()
}

/// Add a new value to the multiset with `key` and `value`.
/// If the key does not exist, it will be created.
/// If the key does exist, the value will be appended to the list of values.
/// Returns the updated multiset.
///
/// # Examples
/// ```
/// let multiset = multi_set.new()
/// let multiset = multi_set.add(multiset, "a", 1)
/// let multiset = multi_set.add(multiset, "a", 2)
/// let multiset = multi_set.add(multiset, "b", 5)
///
/// assert multi_set.get(multiset, "a") == Some([1, 2])
/// assert multi_set.get(multiset, "b") == Some([5])
/// assert multi_set.get(multiset, "c") == None
/// ```
///
pub fn add(to b: MultiSet(a, b), key key: a, value value: b) -> MultiSet(a, b) {
  dict.upsert(b, key, fn(existing) {
    case existing {
      Some(values) -> [value, ..values]
      None -> [value]
    }
  })
}

/// Get the list of keys in the multiset.
///
pub fn keys(b: MultiSet(a, b)) -> List(a) {
  dict.keys(b)
}

/// Get the list of values for the key in the multiset.
/// If the key does not exist, an `Error` is returned.
/// If the key exists, the list of values is returned wrapped in an `Ok`.
///
pub fn get(b: MultiSet(a, b), key: a) -> Result(List(b), Nil) {
  dict.get(b, key)
}

/// Remove a value from the multiset with `key` and `value`.
/// If the key does not exist, the multiset is returned unchanged.
///
pub fn delete(b: MultiSet(a, b), key: a) -> MultiSet(a, b) {
  dict.delete(b, key)
}
