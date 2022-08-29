defmodule Day10 do
  def diffs(input) do
    #fuckin lol you can just sort it
    power_adapter_joltage = Enum.max(input) + 3
    input ++ [0, power_adapter_joltage]
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  def part_1(input) do
    diffs = diffs(input)
    ones = Enum.count(diffs, &(&1 == 1))
    threes = Enum.count(diffs, &(&1 == 3))

    ones * threes
  end

  def part_2(input) do
    diffs(input)
    |> Enum.chunk_by(&(&1))
    |> Enum.map(fn diffs ->
      cond do
        diffs |> hd == 3 ->
          1

        diffs |> hd == 1 ->
          case diffs do
            [1] -> 1
            [1, 1] -> 2
            [1, 1, 1] -> 4
            [1, 1, 1, 1] -> 7
          end
      end
    end)
    |> Enum.reduce(&*/2)
  end
end
