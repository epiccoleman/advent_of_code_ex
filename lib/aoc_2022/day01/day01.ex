defmodule Aoc2022.Day01 do
  @doc """
  Converts the input to a list where each item is a list of each elf's calories
  """
  def process_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn calorie_list_str ->
      calorie_list_str
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_1(input) do
    input
    |> process_input()
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def part_2(input) do
    input
    |> process_input()
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort_by(&(&1), &>=/2) # delightfully gross, sorts in reverse order
    |> Enum.take(3)
    |> Enum.sum()
  end
end
