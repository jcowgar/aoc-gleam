watch year day:
  @zsh -c "while sleep 0.1; do fd -e gleam | entr -d gleam run --no-print-progress -m year_{{year}}/day_{{day}}/solution; done"
