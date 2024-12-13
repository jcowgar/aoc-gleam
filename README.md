# Advent of Code -- Gleam!

An [Advent of Code](https://adventofcode.com) runner for Gleam! This project makes it easy to solve AoC puzzles by providing a quick way of downloading input, generating template source files and running/watching your code for changes. A typical session for solving an AoC puzzle:

```shell
$ just setup 2024 1
$ just watch 2024 1
```

In your code editor, open `src/year_2024/day_1/solution.gleam` and edit away. On save, your code will rerun and display your output.

```shell
year 2021 day 1 part 1 tst = ✅pass (449.0us)
year 2021 day 1 part 1 act = ✅pass (449.0us)
year 2021 day 1 part 2 act = ❌fail (899.0us)
  expected:
    Some(7)
  does not match problem:
    Some(0)
```

Ultimately, when you get the right answer for all steps everything will be green!

## Dependencies

[Just](https://just.systems) is used as a command runner. [entr](https://github.com/eradman/entr) is used to watch the filesystem and re-run your code when changed.

## Important

For `just setup YEAR DAY` to function, you should create a `.env` file in your project directory and set the variable `AOC_SESSION`. For example:

```ini
AOC_SESSION=abc123
```

The `AOC_SESSION` value can be found in your browser cookies.

### Test Scenarios

You can specify a Test scenario. This is the short input for a part and the answer given to the puzzle. If you choose to do the test scenarios, you must create the input for that test manually. Place it in `data/year_YEAR/day_DAY/input_test_PART.txt` for it to be read correctly.

## Example Solution

This is an example solution to 2021 day 1 part 1 may look like using the template created and this `aoc` package.

```gleam
import aoc
import gleam/int
import gleam/io

fn count_increases(last: Int, remaining: List(Int), acc: Int) -> Int {
  case remaining {
    [head, ..rest] if last < head -> count_increases(head, rest, acc + 1)
    [head, ..rest] -> count_increases(head, rest, acc)
    [] -> acc
  }
}

fn part1(problem: aoc.Problem(Int)) -> Int {
  let assert [head, ..rest] = aoc.input_line_mapper(problem, int.parse)

  count_increases(head, rest, 0)
}

fn part2(problem: aoc.Problem(Int)) -> Int {
  -1
}

pub fn main() {
  io.println("")

  aoc.sample(2021, 1, 1, 1) |> aoc.expect(7) |> aoc.run(part1)
  aoc.problem(2021, 1, 1) |> aoc.expect(100) |> aoc.run(part1)
  aoc.problem(2021, 1, 2) |> aoc.run(part2)
}
```
