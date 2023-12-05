defmodule AocUtils.ReplUtils do
  @doc """
  Given a day, a year, and a filename, retrieves the file from that
  day's test directory. Default filename is input.txt.
  """
  def quick_get_input_file(day, year, filename \\ "input.txt") do
    day_num = String.pad_leading(Integer.to_string(day), 2, "0")
    AocUtils.FileUtils.get_file_as_strings("test/aoc_#{year}/day#{day_num}/#{filename}")
  end
end
