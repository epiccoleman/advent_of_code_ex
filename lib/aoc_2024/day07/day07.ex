defmodule Aoc2024.Day07 do
  alias AocUtils.MiscUtils

  def process_line(line_str) do
    [target_num, num_strs] = String.split(line_str, ": ")

    nums =
      num_strs
      |> String.split(" ")
      |> MiscUtils.digitify()

    {String.to_integer(target_num), nums}
  end

  @doc """
  Returns the concatenation of a and b. E.g. concat_nums(4,2) = 42.
  """
  def concat_nums(a, b) do
    String.to_integer(Integer.to_string(a) <> Integer.to_string(b))
  end

  def check_line(target_number, [a, b]) do
    a * b == target_number or a + b == target_number
  end

  def check_line(target_number, [a, b | rest]) do
    check_line(target_number, [a * b | rest]) or
      check_line(target_number, [a + b | rest])
  end

  def check_line_part2(target_number, [a, b]) do
    a * b == target_number or a + b == target_number or concat_nums(a, b) == target_number
  end

  def check_line_part2(target_number, [a, b | rest]) do
    check_line_part2(target_number, [a * b | rest]) or
      check_line_part2(target_number, [a + b | rest]) or
      check_line_part2(target_number, [concat_nums(a, b) | rest])
  end

  def part_1(input) do
    input
    |> Enum.map(&process_line/1)
    |> Enum.map(fn {target, nums} ->
      if check_line(target, nums) do
        target
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Enum.map(&process_line/1)
    |> Enum.map(fn {target, nums} ->
      if check_line_part2(target, nums) do
        target
      else
        0
      end
    end)
    |> Enum.sum()
  end
end
