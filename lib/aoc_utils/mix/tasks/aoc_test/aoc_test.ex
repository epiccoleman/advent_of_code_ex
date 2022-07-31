defmodule Mix.Tasks.Test.Aoc do
  @moduledoc """
  Provides a convenient shorthand for running `mix test` for a given puzzle.

  Call it like this: `mix test.aoc $day $year` - e.g. `mix test.aoc 10 2021`
  """
  def get_test_file_path(day, year) do
    day_number = String.pad_leading(day, 2, "0")
    "test/aoc_#{year}/day#{day_number}"
  end

  def run([day, year | _rest]) do
    test_file_path = get_test_file_path(day, year)
    Mix.Tasks.Test.run([test_file_path])
  end
end

defmodule Mix.Tasks.Test.Aoc.Watch do
  @moduledoc """
  Provides a convenient shorthand for running `mix test.watch` for a given puzzle.

  Call it like this: `mix test.aoc.watch $day $year` - e.g. `mix test.aoc.watch 10 2021`
  """
  def run([day, year | _rest]) do
    test_file_path = Mix.Tasks.Test.Aoc.get_test_file_path(day, year)
    Mix.Tasks.Test.Watch.run([test_file_path])
  end
end
