# Advent of Code -- Gleam!

An [Advent of Code](https://adventofcode.com) runner for Gleam! This project makes it easy to solve AoC puzzles by providing a quick way of downloading input, generating template source files and running/watching your code for changes. A typical session for solving an AoC puzzle:

```bash
$ just setup 2024 1
$ just watch 2024 1
```

In your code editor, open `src/year_2024/day_1/solution.gleam` and edit away. On save, your code will rerun and display your output.

```
year 2021 day 1 part 1 tst = ❌fail (899.0us)
  expected:
    Some(7)
  does not match problem:
    Some(0)
year 2021 day 1 part 1 act = ✅pass (449.0us)
year 2021 day 1 part 2 act = ✅pass (536.0us)
```

Ultimately, when you get the right answer for all steps everything will be green!

## Notes

[Just](https://just.systems) is used as a command runner. [entr](https://github.com/eradman/entr) is used to watch the filesystem and re-run your code when changed.

## Important

For `just setup YEAR DAY` to function, you should create a `.env` file in your project directory and set the variable `AOC_SESSION`. For example:

```
AOC_SESSION=abc123
```

The `AOC_SESSION` value can be found in your browser cookies.
