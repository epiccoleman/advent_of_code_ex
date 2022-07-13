  defmodule Aoc2021.Day02 do
    def move_ship_by_instruction_part1(["forward", scalar], %{x: x, y: y}) do
      %{x: x + scalar,
        y: y}
    end

    def move_ship_by_instruction_part1(["down", scalar], %{x: x, y: y}) do
      %{x: x,
        y: y + scalar}
    end

    def move_ship_by_instruction_part1(["up", scalar], %{x: x, y: y}) do
      %{x: x,
        y: y - scalar}
    end

    def move_ship_by_instruction_part2(["forward", scalar], %{x: x, y: y, aim: aim}) do
      %{x: x + scalar,
        y: y + (aim * scalar),
        aim: aim
      }
    end

    def move_ship_by_instruction_part2(["down", scalar], %{x: x, y: y, aim: aim}) do
      %{x: x,
        y: y,
        aim: aim + scalar
      }
    end

    def move_ship_by_instruction_part2(["up", scalar], %{x: x, y: y, aim: aim}) do
      %{x: x,
        y: y,
        aim: aim - scalar
      }
    end

    def process_input_line(input_line) do
      [instruction, scalar_str] = String.split(input_line, " ")

      [instruction, String.to_integer(scalar_str)]
    end

    def part_1(input) do
      %{x: x, y: y} = input
      |> Enum.map(&process_input_line/1)
      |> Enum.reduce(%{x: 0, y: 0}, &move_ship_by_instruction_part1/2)

      x * y
    end

    def part_2(input) do
      %{x: x, y: y} = input
      |> Enum.map(&process_input_line/1)
      |> Enum.reduce(%{x: 0, y: 0, aim: 0}, &move_ship_by_instruction_part2/2)

      x * y
    end
  end
