defmodule Mix.Tasks.Test.Aoc do
  @moduledoc """
  Provides a convenient shorthand for running `mix test` for a given puzzle.

  Call it like this: `mix test.aoc $day $year` - e.g. `mix test.aoc 10 2021`

  It can also be used to run tests for AocUtils, by passing the module / directory name and "utils" -
  e.g. `mix test.aoc grid utils`
  """
  def get_test_file_path(util, "utils") do
    "test/aoc_utils/#{util}"
  end

  def get_test_file_path(day, year) do
    day_number = String.pad_leading(day, 2, "0")
    "test/aoc_#{year}/day#{day_number}"
  end

  def run([day, year | rest]) do
    test_file_path = get_test_file_path(day, year)
    Mix.Tasks.Test.run([test_file_path] ++ rest)
  end
end

defmodule Mix.Tasks.Test.Aoc.Watch do
  @moduledoc """
  Provides a convenient shorthand for running `mix test.watch` for a given puzzle.

  Call it like this: `mix test.aoc.watch $day $year` - e.g. `mix test.aoc.watch 10 2021`
  """
  def run([day, year | rest]) do
    test_file_path = Mix.Tasks.Test.Aoc.get_test_file_path(day, year)
    Mix.Tasks.Test.Watch.run([test_file_path] ++ rest)
  end
end

defmodule Mix.Tasks.Test.Aoc.Grid do
  @moduledoc """
  Provides a convenient shorthand for running tests for the Grid2D module.

  Runs the test suite for the various Grid2D modules, and also the tests for the following
  puzzles, which utilize Grid2D:
  * AOC2020 - Day 20
  * AOC2021 - Day 9
  * AOC2021 - Day 11
  * AOC2021 - Day 13

  Invoked simply: `mix test.aoc.grid`.
  """

  def run(_args) do
    test_args = [
      "--include", "slow",
      "test/aoc_utils/grid",
      "test/aoc_2020/day20",
      "test/aoc_2021/day09",
      "test/aoc_2021/day11",
      "test/aoc_2021/day13",
    ]
    Mix.Tasks.Test.run(test_args)
  end
end
