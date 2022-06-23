defmodule Day06.Part2 do
  # import Day06, only: [get_locs_for_ranges: 2]
  # currently double defined
  def get_locs_for_ranges(x_range, y_range) do
      for x <- x_range, y <- y_range do
        {x, y}
      end
  end

  @doc """
    this is the top level function called by Day06, change out instruction implementation here
  """
  def do_instructions(instructions) do
    Enum.reduce(instructions, %{}, &(do_instruction_2_merge(&2, &1)))
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

  def do_instruction_2_merge(state_map, {:on, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> Enum.map(fn loc ->
        new_brightness = Map.get(state_map, loc, 0) + 1
        {loc, new_brightness}
      end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  def do_instruction_2_merge(state_map, {:off, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> Enum.map(fn loc ->
        current = Map.get(state_map, loc, 0)
        new_brightness = if current <= 1 do 0 else current - 1 end
        {loc, new_brightness}
      end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  def do_instruction_2_merge(state_map, {:toggle, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> Enum.map(fn loc ->
        new_brightness = Map.get(state_map, loc, 0) + 2
        {loc, new_brightness}
      end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end
end
