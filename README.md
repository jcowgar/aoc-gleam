# Advent of Code -- Gleam!

## Use

Run `just watch YEAR DAY`. This will trigger a series of events in order:

1. If the `YEAR` and `DAY` is in the future, it will sit and wait for December
   `DAY`, `YEAR` at midnight.
2. If the input files do not exist, they will be downloaded into `data/YEAR/DAY`.
3. If code does not exist, boiler plate code will be created in `src/year_YEAR/
   day_DAY/solution.gleam`.
4. It will now execute your code. When a file changes, it will execute your
   code again.
