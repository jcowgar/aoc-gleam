import aoc.{type Problem}
import atomic_array as aa
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import support/grid
import support/grid/direction.{East, North, South, West}

type PlotDict =
  dict.Dict(Int, Plot)

type Plot {
  Plot(
    /// Indexes of each plant in this plot.
    locations: List(Int),
    /// List of plant codes that are touching any plant in this plot.
    perimeter: List(Int),
  )
}

fn parse_data(input: String) -> #(aa.AtomicArray, grid.Grid, PlotDict) {
  let lines = string.split(input, "\n")
  let width = string.length(list.first(lines) |> result.unwrap(""))
  let height = list.length(lines)
  let g = grid.Grid(width, height)
  let garden = aa.new_unsigned(width * height)

  let plot =
    string.replace(input, "\n", "")
    |> string.to_utf_codepoints()
    |> list.map(string.utf_codepoint_to_int)
    |> list.index_map(fn(code, index) {
      let _ = aa.set(garden, index, code)

      code
    })
    |> list.index_fold(dict.new(), fn(plot_dict, plant_code, index) {
      dict.upsert(plot_dict, plant_code, fn(plot: Option(Plot)) {
        let perimeter =
          grid.touching_indexes(g, index, [North, East, South, West])
          |> list.map(fn(this_index) {
            aa.get(garden, this_index)
            |> result.unwrap(-1)
          })
          |> list.filter(fn(touching_plant_code) {
            touching_plant_code != plant_code
          })

        case plot {
          Some(plot) -> {
            Plot(
              [index, ..plot.locations],
              list.flatten([perimeter, plot.perimeter]),
            )
          }
          None -> Plot([index], perimeter)
        }
      })
    })

  #(garden, g, plot)
}

fn plant_code_to_string(code: Int) -> String {
  let assert Ok(plant_code_utf) = string.utf_codepoint(code)
  string.from_utf_codepoints([plant_code_utf])
}

fn part1(problem: Problem(Int)) -> Int {
  let #(_, _, garden) = parse_data(problem.input)

  dict.keys(garden)
  |> list.map(fn(plant_code) {
    let assert Ok(plot) = dict.get(garden, plant_code)
    let area = list.length(plot.locations)
    let perimeter = list.length(plot.perimeter)

    area * perimeter
  })
  |> int.sum()
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   -1
// }

pub fn main() {
  aoc.header(2024, 12)

  // aoc.sample(2024, 12, 1, 1) |> aoc.expect(140) |> aoc.run(part1)
  aoc.sample(2024, 12, 1, 2) |> aoc.expect(772) |> aoc.run(part1)
  // aoc.sample(2024, 12, 1, 2) |> aoc.expect(1930) |> aoc.run(part1)
  // aoc.problem(2024, 12, 1) |> aoc.expect(0) |> aoc.run(part1)

  // aoc.sample(2024, 12, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
  // aoc.problem(2024, 12, 2) |> aoc.expect(0) |> aoc.run(part2)
}
