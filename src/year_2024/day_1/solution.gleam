import aoc.{type Problem}
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/string

type Answer =
  Int

fn parse_list_pair(value: String) -> Result(#(Int, Int), Nil) {
  let assert [a, b] =
    string.split(value, "   ")
    |> list.map(aoc.int)

  Ok(#(a, b))
}

fn part1(problem: Problem(Answer)) -> Answer {
  let #(lista, listb) =
    aoc.input_line_mapper(problem, parse_list_pair)
    |> list.unzip()

  list.zip(list.sort(lista, int.compare), list.sort(listb, int.compare))
  |> list.fold(0, fn(sum, b) { sum + int.absolute_value(b.0 - b.1) })
}

fn part2(problem: Problem(Answer)) -> Answer {
  let #(lista, listb) =
    aoc.input_line_mapper(problem, parse_list_pair)
    |> list.unzip()

  list.fold(lista, 0, fn(sum, a) {
    sum + { a * list.count(listb, fn(b) { b == a }) }
  })
}

fn part2_using_dict(problem: Problem(Answer)) -> Answer {
  let #(lista, listb) =
    aoc.input_line_mapper(problem, parse_list_pair)
    |> list.unzip()

  let frequencies =
    list.fold(listb, dict.new(), fn(acc, v) {
      dict.upsert(acc, v, fn(existing) {
        case existing {
          option.None -> 1
          option.Some(existing_count) -> existing_count + 1
        }
      })
    })

  list.fold(lista, 0, fn(sum, a) {
    case dict.get(frequencies, a) {
      Ok(v) -> sum + { v * a }
      Error(_) -> sum
    }
  })
}

pub fn main() {
  aoc.header(2024, 1)

  aoc.sample(2024, 1, 1, 1) |> aoc.expect(11) |> aoc.run(part1)
  aoc.problem(2024, 1, 1) |> aoc.expect(1_222_801) |> aoc.run(part1)

  aoc.sample(2024, 1, 1, 1) |> aoc.expect(31) |> aoc.run(part2)
  aoc.problem(2024, 1, 2)
  |> aoc.expect(22_545_250)
  |> aoc.run(part2)

  aoc.problem(2024, 1, 2)
  |> aoc.expect(22_545_250)
  |> aoc.run(part2_using_dict)
}
