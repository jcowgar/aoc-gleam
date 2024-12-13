import aoc
import aoc/client
import argv
import dot_env as dot
import dot_env/env
import gleam/io
import gleam/string
import simplifile

const gleam_source = "
import aoc.{type Problem}
import gleam/int

fn part1(problem: Problem(Int)) -> Int {
  let input = aoc.input_line_mapper(problem, int.parse)

  -1
}

// fn part2(problem: Problem(Int)) -> Int {
//   let input = aoc.input_line_mapper(problem, int.parse)
//
//   -1
// }

pub fn main() {
	aoc.header({{year}}, {{day}})

  aoc.sample({{year}}, {{day}}, 1, 1) |> aoc.expect(0) |> aoc.run(part1)
  // aoc.problem({{year}}, {{day}}, 1) |> aoc.expect(0) |> aoc.run(part1)

  // aoc.sample({{year}}, {{day}}, 2, 1) |> aoc.expect(0) |> aoc.run(part2)
	// aoc.problem({{year}}, {{day}}, 2) |> aoc.expect(0) |> aoc.run(part2)
}
"

pub fn main() {
  dot.new()
  |> dot.set_path(".env")
  |> dot.set_debug(False)
  |> dot.load

  let assert [year, day] = argv.load().arguments

  case simplifile.is_file(aoc.input_filename(year, day)) {
    Ok(True) -> Nil
    _ -> download_file(year, day)
  }

  case simplifile.is_file(aoc.solution_filename(year, day)) {
    Ok(True) -> Nil
    _ -> generate_solution_template(year, day)
  }
}

fn download_file(year: String, day: String) -> Nil {
  case simplifile.create_directory_all(aoc.input_filepath(year, day)) {
    Ok(_) -> Nil
    Error(e) -> {
      io.debug(e)

      panic
    }
  }

  let session = case env.get_string("AOC_SESSION") {
    Ok(v) -> v
    Error(e) -> {
      io.debug(e)

      panic
    }
  }

  let assert Ok(body) = client.get_input(year, day, session)

  case simplifile.write(to: aoc.input_filename(year, day), contents: body) {
    Ok(_) -> Nil
    Error(e) -> {
      io.debug(e)

      panic
    }
  }
}

fn generate_solution_template(year: String, day: String) -> Nil {
  let content =
    gleam_source
    |> string.replace("{{year}}", year)
    |> string.replace("{{day}}", day)

  case simplifile.create_directory_all(aoc.solution_filepath(year, day)) {
    Ok(_) -> Nil
    Error(e) -> {
      io.debug(e)

      panic
    }
  }

  case
    simplifile.write(to: aoc.solution_filename(year, day), contents: content)
  {
    Ok(_) -> Nil
    Error(e) -> {
      io.debug(e)

      panic
    }
  }
}
