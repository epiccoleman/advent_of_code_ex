  defmodule Aoc2015.Day02 do
    def paper_required([l,w,h]) do
      side_a = l*w
      side_b = l*h
      side_c = h*w

      slack = Enum.min([side_a, side_b, side_c])

      2 * side_a + 2 * side_b + 2 * side_c + slack
    end

    def ribbon_required([l,w,h] = dims) do
      [small_side_a, small_side_b] = dims -- [Enum.max(dims)]

      2 * small_side_a + 2 * small_side_b + l * w * h
    end

    def num_strings_to_ints(list) do
      Enum.map(list, fn number_str -> String.to_integer(number_str) end)
    end

    def part_1(input) do
      input
      |> Enum.map(&(String.split(&1, "x")))
      |> Enum.map(&num_strings_to_ints/1)
      |> Enum.map(&paper_required/1)
      |> Enum.sum()
    end

    def part_2(input) do
      input
      |> Enum.map(&(String.split(&1, "x")))
      |> Enum.map(&num_strings_to_ints/1)
      |> Enum.map(&ribbon_required/1)
      |> Enum.sum()
    end
  end
