defmodule Day08 do
  defmodule ExecutionState do
    defstruct instructions: [], ip: 0, acc: 0, executed_instructions: MapSet.new
  end

  def execute({:continue, execution_state}) do
    if execution_state.ip >= length(execution_state.instructions) or
        Enum.member?(execution_state.executed_instructions, execution_state.ip)
    do
        {:halt, execution_state}
      else
        [instruction, value_str] = execution_state.instructions |> Enum.at(execution_state.ip) |> String.split(" ")
        value = value_str |> String.to_integer()

        case instruction do
          "acc" ->
            execute({:continue, do_acc(execution_state, value)})
          "jmp" ->
            execute({:continue, do_jmp(execution_state, value)})
        "nop" ->
          execute({:continue, do_nop(execution_state)})
      end

    end
  end

  def execute({:halt, execution_state}) do
    execution_state
  end

  def do_acc(execution_state, value) do
    execution_state
    |> Map.update!(:acc, fn acc -> acc + value end)
    |> Map.update!(:executed_instructions, fn ex_ins -> MapSet.put(ex_ins, execution_state.ip) end)
    |> Map.update!(:ip, fn ip -> ip + 1 end)
  end

  def do_jmp(execution_state, value) do
    execution_state
    |> Map.update!(:executed_instructions, fn ex_ins -> MapSet.put(ex_ins, execution_state.ip) end)
    |> Map.update!(:ip, fn ip -> ip + value end)
  end

  def do_nop(execution_state) do
    execution_state
    |> Map.update!(:executed_instructions, fn ex_ins -> MapSet.put(ex_ins, execution_state.ip) end)
    |> Map.update!(:ip, fn ip -> ip + 1 end)
  end

  def toggle_instruction_at_index(instructions, index) do
    [instruction, val] = Enum.at(instructions, index) |> String.split(" ")

    new_ins = case instruction do
      "jmp" -> "nop " <> val
      "nop" -> "jmp " <> val
    end

    List.replace_at(instructions, index, new_ins)
  end

  def get_indices_of_jmps_and_nops(instructions) do
    instructions
    |> Enum.with_index()
    |> Enum.map(fn {ins, i} ->

      [instruction, _] = String.split(ins, " ")
      case instruction do
        "nop" -> i
        "jmp" -> i
          _  -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end


  def part_1(input) do
    state = %ExecutionState{instructions: input}
    {:halt, end_state} = execute({:continue, state})
    end_state
    |> Map.get(:acc)
  end

  def part_2(input) do
    potential_locations = input |> get_indices_of_jmps_and_nops()

    potential_programs =
      potential_locations
      |> Enum.map(fn target -> toggle_instruction_at_index(input, target) end)

    executions =
      potential_programs
      |> Enum.map(fn program ->
        state = %ExecutionState{instructions: program}
        {_, end_state} = execute({:continue, state})
        end_state
      end)

    executions
    |> Enum.find(fn ex -> ex.ip == 633 end) # 633 is the length of the program, so the execution with this ip is the one we want
    |> Map.get(:acc)
  end
end
