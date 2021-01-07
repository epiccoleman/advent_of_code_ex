defmodule Day01 do
  def part_1(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(0, fn ")", acc -> acc - 1
                          "(", acc -> acc + 1
                      end)
  end

  def part_2(input) do
    input
    |> String.graphemes()
    |> Enum.with_index(1)
    |> Enum.reduce_while(0, fn {direction, index}, acc ->
        next = case direction do
          ")" -> acc - 1
          "(" -> acc + 1
        end

        if next == -1 do
          {:halt, index}
        else
          {:cont, next}
        end
      end)
  end
end
