  defmodule Day06 do
    def process_instruction(instruction_str) do
      [x_0, y_0, x_1, y_1] =
        Regex.scan(~r/\d+/, instruction_str)
        |> Enum.map(fn [i] -> String.to_integer(i) end)

      cond do
        instruction_str =~ "on" ->  {:on, x_0..x_1, y_0..y_1}
        instruction_str =~ "off" -> {:off, x_0..x_1, y_0..y_1}
        instruction_str =~ "toggle" -> {:toggle, x_0..x_1, y_0..y_1}
      end
    end

    def get_locs_for_ranges(x_range, y_range) do
      for x <- x_range, y <- y_range do
        {x, y}
      end
    end

    def process_input(input) do
      input
      |> Enum.map(&process_instruction/1)
    end

    def part_1(input) do
      input
      |> process_input()
      |> Day06.Part1.do_instructions()
      |> Enum.count(fn {_, state} -> state == :on end)
    end

    def part_2(input) do
      input
      |> process_input()
      |> Day06.Part2.do_instructions()
      |> Enum.reduce(0, fn {_, brightness}, acc -> acc + brightness end )
    end
  end
