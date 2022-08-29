defmodule Day14 do
  def to_bit_list(number) do
    :io_lib.format("~36.2.0B", [number])
    |> to_string()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def apply_bitmask(value, mask) do
    value_bits = to_bit_list(value)

    changes = find_change_indices(mask)

    Enum.reduce(changes, value_bits, fn {change_v, change_i}, acc ->
      acc |> List.replace_at(change_i, String.to_integer(change_v))
    end)
    |> Integer.undigits(2)
  end

  def find_change_indices(mask) do
    mask
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {v, _i} -> v == "1" or v == "0" end)
  end

  def handle_instruction(state, instruction) do
    case String.at(instruction, 1) do
      "a" -> handle_mask_instruction(state, instruction)
      "e" -> handle_mem_instruction(state, instruction)
    end
  end

  def handle_mask_instruction(state, instruction) do
    [ _junk, new_mask ] = String.split(instruction, " = ")

    Map.put(state, :mask, new_mask)
  end

  def handle_mem_instruction(state, instruction) do
    [addr_str, value_str] = String.split(instruction, " = ")

    value = apply_bitmask(String.to_integer(value_str), state.mask)
    [_, memory_address_str] = Regex.run(~r{\[(.*)\]}, addr_str)
    memory_address = String.to_integer(memory_address_str)

    new_memory = state.memory |> Map.put(memory_address, value)
    state |> Map.put(:memory, new_memory)
  end

  def handle_instruction_2(state, instruction) do
    case String.at(instruction, 1) do
      "a" -> handle_mask_instruction(state, instruction)
      "e" -> handle_mem_instruction_2(state, instruction)
    end
  end

  def handle_mem_instruction_2(state, instruction) do
    [addr_str, value_str] = String.split(instruction, " = ")

    # this gets written to several memory locations
    value = String.to_integer(value_str)

    [_, memory_address_str] = Regex.run(~r{\[(.*)\]}, addr_str)

    # the original address which will be transformed into a list of locations to write to
    original_memory_address = String.to_integer(memory_address_str)

    memory_addresses = get_address_permutations(original_memory_address, state.mask)

    new_memory = Enum.reduce(memory_addresses, state.memory, fn address, memory ->
      memory |> Map.put(address, value)
    end)

    state |> Map.put(:memory, new_memory)
  end

  def get_address_permutations(original_addr, mask) do
    ones_addrs =
      mask
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {v, _i} -> v == "1" end)

    floating_addrs =
      mask
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {v, _i} -> v == "X" end)

    orig_addr_bit_list = original_addr
    |> to_bit_list()

    # a bit list of the address with all the 1s in the mask applied, ready to go through the process of floating
    # we all float down here
    address_ready_for_floating = Enum.reduce(ones_addrs, orig_addr_bit_list, fn {_, change_i}, acc ->
      acc |> List.replace_at(change_i, 1)
    end)

    do_the_float(address_ready_for_floating, floating_addrs) |> Enum.map(&(Integer.undigits(&1, 2)))
  end

  def do_the_float(address_bits, [ {_x, float_here} | float_locations ])  do
    floated_to_1 = List.replace_at(address_bits, float_here, 1)
    floated_to_0 = List.replace_at(address_bits, float_here, 0)

    if Enum.empty?(float_locations) do
      [ floated_to_0, floated_to_1 ]
    else
      Enum.flat_map([floated_to_0, floated_to_1], fn addr -> do_the_float(addr, float_locations) end)
    end
  end

  def part_1(input) do
    state = input
    |> Enum.reduce(%{mask: "", memory: %{}}, fn instruction,state ->
      handle_instruction(state, instruction)
    end)

    state.memory
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  def part_2(input) do
    state = input
    |> Enum.reduce(%{mask: "", memory: %{}}, fn instruction, state ->
      handle_instruction_2(state, instruction)
    end)

    state.memory
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end
end
