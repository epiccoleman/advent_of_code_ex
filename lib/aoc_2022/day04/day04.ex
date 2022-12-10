defmodule Aoc2022.Day04 do
  def process_input_line(input_line) do
    regex = ~r/(?<a>\d+)-(?<b>\d+),(?<c>\d+)-(?<d>\d+)/x
    range_nums = Regex.named_captures(regex, input_line)

    {String.to_integer(range_nums["a"])..String.to_integer(range_nums["b"]),
     String.to_integer(range_nums["c"])..String.to_integer(range_nums["d"])}
  end

  def check_if_one_range_fully_contains_the_other({r1, r2}) do
    r1_set = MapSet.new(r1)
    r2_set = MapSet.new(r2)

    {smaller_range, larger_range} = if MapSet.size(r1_set) > MapSet.size(r2_set) do
      {r2_set, r1_set}
    else
      {r1_set, r2_set}
    end

    MapSet.intersection(larger_range, smaller_range) == smaller_range
  end

  def check_if_one_range_partially_contains_the_other({r1, r2}) do
    r1_set = MapSet.new(r1)
    r2_set = MapSet.new(r2)

    intersection = MapSet.intersection(r1_set, r2_set)
    MapSet.size(intersection) > 0
  end


  def part_1(input) do
    input
    |> Enum.map(&process_input_line/1)
    |> Enum.map(&check_if_one_range_fully_contains_the_other/1)
    |> Enum.count(fn x -> x end)
  end

  def part_2(input) do
    input
    |> Enum.map(&process_input_line/1)
    |> Enum.map(&check_if_one_range_partially_contains_the_other/1)
    |> Enum.count(fn x -> x end)
  end
end
