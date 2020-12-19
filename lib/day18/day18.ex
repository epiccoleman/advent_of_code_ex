  defmodule Day18 do

    def evaluate([a, op, b | rest]) do
      a_eval = if is_list(a) do evaluate(a) else a end
      b_eval = if is_list(b) do evaluate(b) else b end

      operation = case op do
        '+' -> &+/2
        '-' -> &-/2
        '*' -> &*/2
        '/' -> &//2
      end

      evaluate([operation.(a_eval, b_eval)] ++ rest)
    end

    def evaluate([value]) do
      value
    end
    def evaluate(input_line) when is_binary(input_line) do
      Day18.Parser.parse(input_line)
      |> evaluate()
    end

    def part_1(input) do
      input
      |> Enum.map(&evaluate/1)
      |> Enum.sum()
    end

    def part_2(input) do
      input
    end
  end
