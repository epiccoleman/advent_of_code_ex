defmodule Aoc2022.Day05 do
  def process_input(input) do
    [stack_strs, instruction_strs] = String.split(input, "\n\n")

    stacks =
      stack_strs
      |> String.split("\n")
      |> Enum.map(fn stack_str ->
        [number, stack] = String.split(stack_str, ": ")
        {String.to_integer(number), String.graphemes(stack)}
      end)
      |> Map.new()

    regex = ~r/move (?<move_count>\d+) from (?<source>\d+) to (?<target>\d+)/
    instructions =
      instruction_strs
      |> String.split("\n")
      |> Enum.map(fn instruction_str ->
        captures = Regex.named_captures(regex, instruction_str)
        %{
          move_count: String.to_integer(captures["move_count"]),
          target: String.to_integer(captures["target"]),
          source: String.to_integer(captures["source"]),
        }
      end)

    %{stacks: stacks, instructions: instructions}
  end

  def do_instruction_for_cratemover_9000(
    %{move_count: move_count,
      source: source,
      target: target } = _instruction,
    stacks) do

    source_stack = stacks[source]
    target_stack = stacks[target]

    { crates_to_move, new_source_stack } = Enum.split(source_stack, move_count)

    new_target_stack = Enum.reverse(crates_to_move) ++ target_stack

    %{stacks | source => new_source_stack, target => new_target_stack}
  end

  def do_instruction_for_cratemover_9001(
    %{move_count: move_count,
      source: source,
      target: target } = _instruction,
    stacks) do

    source_stack = stacks[source]
    target_stack = stacks[target]

    { crates_to_move, new_source_stack } = Enum.split(source_stack, move_count)

    new_target_stack = crates_to_move ++ target_stack

    %{stacks | source => new_source_stack, target => new_target_stack}
  end

  @doc """
  Returns the state of the stack after the list of instructions have been performed
  """
  def do_instructions(instructions, stacks, instruction_fn) do
    instructions
    |> Enum.reduce(stacks, fn instruction, stack_acc ->
      instruction_fn.(instruction, stack_acc)
    end)
  end

  def print_top_of_each_stack(stacks) do
    Enum.reduce(stacks, "", fn {_k, v}, acc ->
      acc <> hd(v)
    end)
  end

  def part_1(input) do
    parsed_input = input |> process_input()
    final_stacks = do_instructions(parsed_input.instructions, parsed_input.stacks, &do_instruction_for_cratemover_9000/2)

    print_top_of_each_stack(final_stacks)
  end

  def part_2(input) do
    parsed_input = input |> process_input()
    final_stacks = do_instructions(parsed_input.instructions, parsed_input.stacks, &do_instruction_for_cratemover_9001/2)

    print_top_of_each_stack(final_stacks)
  end
end
