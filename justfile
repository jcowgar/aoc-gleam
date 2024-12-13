# List available recipes
ls:
	@just --list

# Setup a new day
setup year day:
  @gleam run -m aoc/setup -- {{year}} {{day}}

# Run a particular year/day solution
run year day:
  @gleam run --no-print-progress -m year_{{year}}/day_{{day}}/solution

# Rerun (watch) a day when source changes
watch year day:
  @zsh -c "while sleep 0.1; do fd -e gleam | entr -d gleam run --no-print-progress -m year_{{year}}/day_{{day}}/solution; done"

# Work the year/day... this is the equivilent of setup and watch
work year day:
	@just setup {{year}} {{day}}
	@just watch {{year}} {{day}}

# Test
test:
    @gleam test

# Run tests in watch mode.
test-watch:
    @zsh -c "while sleep 0.1; do fd -e gleam | entr -d gleam test ; done"
