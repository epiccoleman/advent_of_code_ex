defmodule Aoc2023.Day06 do
  def process_input(input) do
    Enum.map(input, fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def simulate_race({race_time, distance_record}) do
    Enum.map(1..(race_time - 1), fn time_holding_button ->
      ms_per_s = time_holding_button
      remaining_seconds = race_time - time_holding_button
      distance = ms_per_s * remaining_seconds

      {time_holding_button, distance, distance > distance_record}
    end)
  end

  @doc """
  Solves the race using the quadratic equation. This only works for quadratic equations
  of the form -ax^2 + bx, which is what our problem uses.
  """
  def solve_race({race_time, distance_record}) do
    discriminant = race_time ** 2 - 4 * -1 * -distance_record
    sqrt_discriminant = :math.sqrt(discriminant)

    x1 = (-race_time + sqrt_discriminant) / -2
    x2 = (-race_time - sqrt_discriminant) / -2

    ceil(x2) - 1 - (floor(x1) + 1)
  end

  def part_1_brute_force(input) do
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

  def part_1(input) do
    input
    |> process_input()
    |> Enum.map(&solve_race/1)
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

  def part_2_brute_force(input) do
    input
    |> process_input_2()
    |> simulate_race()
    |> Enum.filter(fn {_, _, win} -> win end)
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> process_input_2()
    |> solve_race()
  end
end
