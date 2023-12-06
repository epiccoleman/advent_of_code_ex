defmodule AocUtils.ReplUtils do
  @doc """
  Given a day, a year, and a filename, retrieves the file from that
  day's test directory. Default filename is input.txt.
  """
  def quick_get_input_strings(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    AocUtils.FileUtils.get_file_as_strings("test/aoc_#{year}/day#{day_num}/#{filename}")
  end

  def quick_get_input_strings(filename) do
    AocUtils.FileUtils.get_file_as_strings(filename)
  end

  def quick_get_input_nums(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    AocUtils.FileUtils.get_file_as_integers("test/aoc_#{year}/day#{day_num}/#{filename}")
  end

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

  def quick_get_input_file(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    File.read!("test/aoc_#{year}/day#{day_num}/#{filename}")
  end

  def quick_get_input_file(filename) do
    File.read!(filename)
  end
end
