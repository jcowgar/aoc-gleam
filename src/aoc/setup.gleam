import aoc
import aoc/client
import argv
import dot_env as dot
import dot_env/env
import gleam/io
import simplifile

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
