defmodule Aoc2023.Day06 do
  def process_input(input) do
    Enum.map(input, fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def simulate_race({time, distance_record}) do
    Enum.map(1..(time - 1), fn i ->
      ms_per_s = i
      remaining_seconds = time - i
      distance = ms_per_s * remaining_seconds

      {i, distance, distance > distance_record}
    end)
  end

  def part_1(input) do
    input
    |> process_input()
    |> Enum.map(&simulate_race/1)
    |> Enum.map(fn races ->
      races
      |> Enum.filter(fn {_, _, win} -> win end)
      |> Enum.count()
    end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def process_input_2(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.split(":")
      |> then(fn [_, nums] -> nums end)
      |> String.split()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Integer.undigits()
    end)
    |> List.to_tuple()
  end

  def part_2(input) do
    input
    |> process_input_2()
    |> simulate_race()
    |> Enum.filter(fn {_, _, win} -> win end)
    |> Enum.count()
  end
end
