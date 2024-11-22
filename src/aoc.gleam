import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string
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

pub fn report(problem: Problem(a)) {
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
      io.println("❓unchecked result:")
      io.print("    ")
      io.debug(problem.answer)

      Nil
    }

    Some(_) if problem.expect == problem.answer -> {
      io.println("✅pass")

      Nil
    }

    Some(_) -> {
      io.println("❌fail")
      io.println("  expected:")
      io.print("    ")
      io.debug(problem.expect)
      io.println("  does not match problem:")
      io.print("    ")
      io.debug(problem.answer)

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
  let answer = f(problem)

  Problem(..problem, answer: Some(answer))
  |> report()
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
