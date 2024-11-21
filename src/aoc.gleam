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

  io.println("")
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
      io.println("🤷unchecked result:")
      io.print("    ")
      io.debug(problem.answer)

      Nil
    }

    Some(_) if problem.expect == problem.answer -> {
      io.println("🥳pass")

      Nil
    }

    Some(_) -> {
      io.println("💥fail")
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
  let type_val = case problem_type {
    Test -> "_test_" <> int.to_string(part)
    Actual -> ""
  }

  let assert Ok(content) =
    simplifile.read(
      "data/"
      <> int.to_string(year)
      <> "/day_"
      <> int.to_string(day)
      <> "/input"
      <> type_val
      <> ".txt",
    )

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
