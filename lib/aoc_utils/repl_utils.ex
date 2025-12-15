defmodule AocUtils.ReplUtils do
  @moduledoc """
  Handy utilities for use in the REPL.
  """

  @doc """
  Given a day, a year, and a filename, retrieves the contents of the input file as a list of strings from that
  day's test directory. Default filename is input.txt.

  ## Examples

      > quick_get_input_strings(2, 2025)
      # returns strings for input.txt from test/aoc_2025/day02/

      > quick_get_input_strings(2, 2025, "input_small.txt")
      # returns strings for input_small.txt from test/aoc_2025/day02/
  """
  def quick_get_input_strings(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    AocUtils.FileUtils.get_file_as_strings("test/aoc_#{year}/day#{day_num}/#{filename}")
  end

  @doc """
  Alias for AocUtils.FileUtils.get_file_as_strings/1, just reads in the given file as a list of strings.
  """
  def quick_get_input_strings(filename) do
    AocUtils.FileUtils.get_file_as_strings(filename)
  end

  @doc """
  Given a day, a year, and a filename, retrieves the contents of the input file as a list of numbers from that
  day's test directory. Default filename is input.txt.

  ## Examples

      > quick_get_input_numbers(2, 2025)
      # returns numbers for input.txt from test/aoc_2025/day02/

      > quick_get_input_numbers(2, 2025, "input_small.txt")
      # returns numbers for input_small.txt from test/aoc_2025/day02/
  """
  def quick_get_input_nums(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    AocUtils.FileUtils.get_file_as_integers("test/aoc_#{year}/day#{day_num}/#{filename}")
  end

  @doc """
  Alias for AocUtils.FileUtils.get_file_as_integers/1, just reads in the given file as a list of integers.
  """
  @spec quick_get_input_nums(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: list()
  def quick_get_input_nums(filename) do
    AocUtils.FileUtils.get_file_as_integers(filename)
  end

  @doc """
  Given a day, a year, and a filename, retrieves the contents of the input file with no post-processing.

  ## Examples

      > quick_get_input_strings(2, 2025)
      # returns content of input.txt from test/aoc_2025/day02/

      > quick_get_input_strings(2, 2025, "input_small.txt")
      # returns content of input_small.txt from test/aoc_2025/day02/
  """
  def quick_get_input_file(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    File.read!("test/aoc_#{year}/day#{day_num}/#{filename}")
  end

  @doc """
  Pointless longer alias for File.read!/1, here only because I am a slave to patterns.
  """
  def quick_get_input_file(filename) do
    File.read!(filename)
  end
end
