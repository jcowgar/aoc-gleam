import birl
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import humanise/time
import simplifile

pub type ProblemType {
  Test
  Actual
}

pub type Problem(a) {
  Problem(
    problem_type: ProblemType,
    year: Int,
    day: Int,
    part: Int,
    input: String,
    expect: Option(a),
    answer: Option(a),
  )
}

pub fn report(problem: Problem(a), elapsed) {
  let elapsed_as_string =
    time.humanise(time.Microseconds(int.to_float(elapsed))) |> time.to_string()
  let problem_type = case problem.problem_type {
    Test -> "tst"
    Actual -> "act"
  }

  io.print(
    "  part " <> int.to_string(problem.part) <> " " <> problem_type <> " = ",
  )

  case problem.input {
    "" -> {
      io.println(
        "🙈 no input content, does file exist? (" <> elapsed_as_string <> ")",
      )
    }

    _ ->
      case problem.expect {
        None -> {
          io.println("❓unchecked (" <> elapsed_as_string <> ")")
          io.print("      ")
          io.println(string.inspect(problem.answer))
        }

        Some(_) if problem.expect == problem.answer -> {
          io.println("✅ pass (" <> elapsed_as_string <> ")")
        }

        Some(_) -> {
          io.println("❌ fail (" <> elapsed_as_string <> ")")
          io.println("    expected:")
          io.print("      ")
          io.println(string.inspect(problem.expect))
          io.println("    but got:")
          io.println("      " <> string.inspect(problem.answer))
        }
      }
  }
}

/// Display a year/day header
///
pub fn header(year: Int, day: Int) {
  io.println("")
  io.println(
    "Advent of Code: year "
    <> int.to_string(year)
    <> " day "
    <> int.to_string(day),
  )
}

/// Create a new problem statement.
///
pub fn problem(
  problem_type: ProblemType,
  year: Int,
  day: Int,
  part: Int,
) -> Problem(a) {
  let file_content =
    case problem_type {
      Test ->
        input_test_filename(
          int.to_string(year),
          int.to_string(day),
          int.to_string(part),
        )
      Actual -> input_filename(int.to_string(year), int.to_string(day))
    }
    |> simplifile.read()

  let content = case file_content {
    Ok(content) -> content
    Error(_) -> ""
  }

  Problem(
    problem_type:,
    year:,
    day:,
    part:,
    input: content |> string.trim_end(),
    answer: None,
    expect: None,
  )
}

pub fn run(problem: Problem(a), f) {
  let #(elapse_time, answer) = case problem.input {
    "" -> #(0, None)
    _content -> {
      let start_time = birl.monotonic_now()
      let answer = f(problem)
      let end_time = birl.monotonic_now()

      #(end_time - start_time, Some(answer))
    }
  }

  Problem(..problem, answer: answer)
  |> report(elapse_time)
}

pub fn expect(problem: Problem(a), value: a) -> Problem(a) {
  Problem(..problem, expect: Some(value))
}

pub fn input_filepath(year: String, day: String) -> String {
  "data/year_" <> year <> "/day_" <> day
}

pub fn input_filename(year: String, day: String) -> String {
  input_filepath(year, day) <> "/input.txt"
}

pub fn input_test_filename(year: String, day: String, part: String) -> String {
  input_filepath(year, day) <> "/input_test_" <> part <> ".txt"
}

pub fn solution_filepath(year: String, day: String) -> String {
  "src/year_" <> year <> "/day_" <> day
}

pub fn solution_filename(year: String, day: String) -> String {
  solution_filepath(year, day) <> "/solution.gleam"
}

/// Parse the input content line-by-line according to `f`.
///
pub fn input_line_mapper(
  problem: Problem(a),
  f: fn(String) -> Result(b, c),
) -> List(b) {
  case problem.input |> string.split("\n") |> list.try_map(f) {
    Ok(values) -> values
    Error(e) -> {
      io.println_error(string.inspect(e))

      panic
    }
  }
}

/// Parse the input content on a character basis according to `f`.
///
pub fn input_grapheme_mapper(
  problem: Problem(a),
  f: fn(String) -> Result(b, c),
) -> List(b) {
  case problem.input |> string.to_graphemes() |> list.try_map(f) {
    Ok(values) -> values
    Error(e) -> {
      io.println_error(string.inspect(e))

      panic
    }
  }
}

pub fn int_or_panic(value: String) -> Int {
  case int.parse(value) {
    Ok(v) -> v
    _ -> {
      io.println_error("could not parse integer '" <> value <> "'")

      panic
    }
  }
}
