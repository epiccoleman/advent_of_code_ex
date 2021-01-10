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

    def do_instruction(state_map, {:on, x_range, y_range}) do
      locs = get_locs_for_ranges(x_range, y_range)
      Enum.reduce(locs, state_map, &(Map.put(&2, &1, :on)))
    end

    def do_instruction(state_map, {:off, x_range, y_range}) do
      locs = get_locs_for_ranges(x_range, y_range)
      Enum.reduce(locs, state_map, &(Map.put(&2, &1, :off)))
    end

    def do_instruction(state_map, {:toggle, x_range, y_range}) do
      locs = get_locs_for_ranges(x_range, y_range)
      Enum.reduce(locs, state_map, &(Map.update(&2, &1, :on, fn :off -> :on
                                                                :on -> :off end)))
    end

    def do_instruction_2(state_map, {:on, x_range, y_range}) do
      locs = get_locs_for_ranges(x_range, y_range)
      Enum.reduce(locs, state_map, fn pos, acc -> Map.update(acc, pos, 1, &(&1 + 1)) end)
    end

    def do_instruction_2(state_map, {:off, x_range, y_range}) do
      locs = get_locs_for_ranges(x_range, y_range)
      Enum.reduce(locs, state_map, fn pos, acc ->
        Map.update(acc, pos, 0, fn brightness ->
          new = brightness - 1
          if new < 0 do 0 else new end
        end)
      end)
    end

    def do_instruction_2(state_map, {:toggle, x_range, y_range}) do
      locs = get_locs_for_ranges(x_range, y_range)
      Enum.reduce(locs, state_map, fn pos, acc -> Map.update(acc, pos, 2, &(&1 + 2))end)
    end

    def do_instructions(instructions) do
      Enum.reduce(instructions, %{}, &(do_instruction(&2, &1)))
    end

    def do_instructions_2(instructions) do
      Enum.reduce(instructions, %{}, &(do_instruction_2(&2, &1)))
    end

    def process_input(input) do
      input
      |> Enum.map(&process_instruction/1)
    end

    def part_1(input) do
      input
      |> process_input()
      |> do_instructions()
      |> Enum.count(fn {_, state} -> state == :on end)
    end

    def part_2(input) do
      input
      |> process_input()
      |> do_instructions_2()
      |> Enum.reduce(0, fn {_, brightness}, acc -> acc + brightness end )
    end
  end
