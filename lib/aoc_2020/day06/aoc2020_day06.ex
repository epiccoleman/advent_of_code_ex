defmodule Day06 do

  def process_group_1(group_str) do
    group_str
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.union/2)
  end

  def process_group_2(group_str) do
    group_str
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
  end

  def part_1(input) do
    input
    |> Enum.map(&process_group_1/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  def part_2(input) do
    input
    |> Enum.map(&process_group_2/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&Kernel.+/2)
  end
end
