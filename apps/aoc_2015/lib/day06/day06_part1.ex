defmodule Day06.Part1 do
  import Day06, only: [get_locs_for_ranges: 2]

  @doc """
    this is the top level function called by Day06, change out instruction implementation here
  """
  def do_instructions(instructions) do
    Enum.reduce(instructions, %{}, &(do_instruction_merge(&2, &1)))
  end


  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end


  ###

  def do_instruction_merge_parallel(state_map, {:on, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> pmap(fn loc -> {loc, :on} end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  ###

  def do_instruction_merge_parallel(state_map, {:on, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> pmap(fn loc -> {loc, :on} end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  def do_instruction_merge_parallel(state_map, {:off, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> pmap(fn loc -> {loc, :off} end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  def do_instruction_merge_parallel(state_map, {:toggle, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> pmap(fn loc ->
        current = Map.get(state_map, loc, :off)

        new_state =
          case current do
            :off -> :on
            :on -> :off
          end

        {loc, new_state}
      end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end


  ###

  def do_instruction_merge(state_map, {:on, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> Enum.map(fn loc -> {loc, :on} end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  def do_instruction_merge(state_map, {:off, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> Enum.map(fn loc -> {loc, :off} end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end

  def do_instruction_merge(state_map, {:toggle, x_range, y_range}) do
    updates =
      get_locs_for_ranges(x_range, y_range)
      |> Enum.map(fn loc ->
        current = Map.get(state_map, loc, :off)

        new_state =
          case current do
            :off -> :on
            :on -> :off
          end

        {loc, new_state}
      end)
      |> Enum.into(%{})

    Map.merge(state_map, updates)
  end


  ### Original version - slow, deprecated
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
end
