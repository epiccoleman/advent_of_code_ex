  defmodule Aoc2021.Day01 do
    @doc """
    The first order of business is to figure out how quickly the depth increases, just so you
    know what you're dealing with - you never know if the keys will get carried into deeper water
    by an ocean current or a fish or something.

    To do this, count the number of times a depth measurement increases from the previous measurement.
    """
    def part_1(input) do
      input
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.count(fn [a, b] -> a < b end)
    end


    @doc """
    Considering every single measurement isn't as useful as you expected: there's just too
    much noise in the data. Instead, consider sums of a three-measurement sliding window.

    Your goal now is to count the number of times the sum of measurements in this sliding window
    increases from the previous sum.
    """
    def part_2(input) do
      input
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum/1)
      |> part_1()
    end
  end
