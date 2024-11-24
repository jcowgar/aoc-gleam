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
    "year "
    <> int.to_string(problem.year)
    <> " day "
    <> int.to_string(problem.day)
    <> " part "
    <> int.to_string(problem.part)
    <> " "
    <> problem_type
    <> " = ",
  )

  case problem.expect {
    None -> {
      io.println("❓unchecked (" <> elapsed_as_string <> ")")
      io.print("    ")
      io.debug(problem.answer)

      Nil
    }

    Some(_) if problem.expect == problem.answer -> {
      io.println("✅pass (" <> elapsed_as_string <> ")")

      Nil
    }

    Some(_) -> {
      io.println("❌fail (" <> elapsed_as_string <> ")")
      io.println("  expected:")
      io.print("    ")
      io.debug(problem.expect)
      io.println("  does not match problem:")
      io.println("    " <> string.inspect(problem.answer))

      Nil
    }
  }
}

pub fn problem(
  problem_type: ProblemType,
  year: Int,
  day: Int,
  part: Int,
) -> Problem(a) {
  let assert Ok(content) =
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
  let start_time = birl.monotonic_now()
  let answer = f(problem)
  let end_time = birl.monotonic_now()

  Problem(..problem, answer: Some(answer))
  |> report(end_time - start_time)
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
