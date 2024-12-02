defmodule Aoc2024.Day01 do
  @doc """
  Turn lines of input formatted like in the puzzle into two lists
  """
  def lists_from_input(lines) do
    {l1, l2} =
      Enum.reduce(lines, {[], []}, fn line, {l1, l2} ->
        [term1, term2] = String.split(line) |> Enum.map(&String.to_integer/1)

        {[term1 | l1], [term2 | l2]}
      end)

    {Enum.reverse(l1), Enum.reverse(l2)}
  end

  @doc """
  Pair up the lists, in order of size, then measure the distances, and sum them.
  """
  def list_distance({list1, list2}) do
    Enum.zip(Enum.sort(list1), Enum.sort(list2))
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  @doc """
  Score the similarity of the two lists by adding up each number in l1
  after multiplying it by the number of times that number appears in l2.
  """
  def similarity_score({l1, l2}) do
    freqs = Enum.frequencies(l2)

    l1
    |> Enum.map(fn term ->
      term_count = Map.get(freqs, term, 0)
      term * term_count
    end)
    |> Enum.sum()
  end

  def part_1(input) do
    input
    |> lists_from_input()
    |> list_distance()
  end

  def part_2(input) do
    input
    |> lists_from_input()
    |> similarity_score()
  end
end
