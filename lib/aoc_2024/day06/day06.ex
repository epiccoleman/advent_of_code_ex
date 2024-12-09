defmodule Aoc2024.Day06 do
  alias Aoc2024.Day06.GuardState
  alias Aoc2024.Day06.GuardState
  alias AocUtils.Grid2D

  defmodule GuardState do
    defstruct grid: %Grid2D{},
              guard_loc: {0, 0},
              guard_dir: :up,
              visited: MapSet.new(),
              visited_obstacles: []
  end

  @doc """
  Constructs a "GuardState" struct from the input file
  """
  def process_input(input) do
    grid = Grid2D.from_strs(input, ignore: ".")

    guard_loc = Grid2D.matching_locs(grid, fn {_loc, v} -> v == "^" end) |> hd()

    grid = Grid2D.delete(grid, guard_loc)

    %GuardState{
      grid: grid,
      guard_loc: guard_loc
    }
  end

  @doc """
  Turns the guard 90 degrees to the right.
  """
  def turn_guard(%GuardState{guard_dir: dir} = state) do
    new_dir =
      case dir do
        :up -> :right
        :right -> :down
        :down -> :left
        :left -> :up
      end

    %{
      state
      | guard_dir: new_dir
    }
  end

  @doc """
  Returns true if the guard is facing an obstacle at his current location
  """
  def obstacle?(%GuardState{grid: grid, guard_loc: {x, y}, guard_dir: dir} = _guard_state) do
    loc_to_check =
      case dir do
        :up -> {x, y - 1}
        :right -> {x + 1, y}
        :down -> {x, y + 1}
        :left -> {x - 1, y}
      end

    Grid2D.at(grid, loc_to_check) == "#"
  end

  @doc """
  Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:

  If there is something directly in front of you, turn right 90 degrees.
  Otherwise, take a step forward.
  """
  def step_guard(
        %GuardState{
          guard_loc: {x, y},
          guard_dir: dir,
          visited: visited,
          visited_obstacles: visited_obstacles
        } = guard_state
      ) do
    new_visited = MapSet.put(visited, {x, y})

    next_spot =
      case dir do
        :up -> {x, y - 1}
        :right -> {x + 1, y}
        :down -> {x, y + 1}
        :left -> {x - 1, y}
      end

    if obstacle?(guard_state) do
      turn_guard(%{
        guard_state
        | visited: new_visited,
          visited_obstacles: [next_spot | visited_obstacles]
      })
    else
      new_loc =
        case dir do
          :up -> {x, y - 1}
          :right -> {x + 1, y}
          :down -> {x, y + 1}
          :left -> {x - 1, y}
        end

      %GuardState{guard_state | guard_loc: new_loc, visited: new_visited}
    end
  end

  @doc """
  Runs the guard through his "patrol protocol" until he runs off the grid.
  """
  def simulate_guard(%GuardState{grid: grid, guard_loc: loc} = guard_state) do
    if not Grid2D.within_boundaries?(grid, loc) do
      guard_state
    else
      guard_state
      |> step_guard()
      |> simulate_guard()
    end
  end

  @doc """
  Checks for a 4-node cycle. If the same list of 4 nodes appears twice in a row, then we're
  stuck in a loop. (I think?).
  """
  def has_cycle?([]) do
    false
  end

  def has_cycle?(list) do
    current = hd(list)

    prev_visit_of_same_node = Enum.find_index(Enum.drop(list, 1), fn pos -> pos == current end)

    if prev_visit_of_same_node != nil do
      visited_since_last_time_we_saw_same_obstacle = Enum.take(list, prev_visit_of_same_node + 1)

      potential_cycle_before_this_one =
        Enum.slice(list, prev_visit_of_same_node + 1, prev_visit_of_same_node + 1)

      length(list) >= 8 and
        visited_since_last_time_we_saw_same_obstacle == potential_cycle_before_this_one
    else
      false
    end

    # length(list) >= 8 and last_four == second_last_four
  end

  @doc """
  Runs the guard through his "patrol protocol" until he runs off the grid.
  """
  def simulate_guard_with_cycle_detection(
        %GuardState{grid: grid, guard_loc: loc, visited_obstacles: visited_obstacles} =
          guard_state
      ) do
    cond do
      Grid2D.at(grid, loc) == "#" ->
        {:invalid, guard_state}

      not Grid2D.within_boundaries?(grid, loc) ->
        {:exited, guard_state}

      has_cycle?(visited_obstacles) ->
        {:cycle, guard_state}

      true ->
        guard_state
        |> step_guard()
        |> simulate_guard_with_cycle_detection()
    end

    # if
    #   {:exited, guard_state}
    # else
    #   if(length(vos) >= 8)
    # else
    #   guard_state
    #   |> step_guard()
    #   |> simulate_guard()
    # end
  end

  def part_1(input) do
    input
    |> process_input()
    |> simulate_guard()
    |> then(fn %{visited: visited} -> MapSet.size(visited) end)
  end

  def part_2_brute_force(input) do
    initial_state =
      input
      |> process_input()

    visited =
      initial_state
      |> simulate_guard()
      |> then(fn %{visited: visited} -> visited end)

    visited
    |> Enum.map(fn node_to_try ->
      try_state = %{initial_state | grid: Grid2D.update(initial_state.grid, node_to_try, "#")}

      # IO.puts("trying with obstacle at #{inspect(node_to_try)}")
      simulate_guard_with_cycle_detection(try_state)
    end)
    |> Enum.count(fn
      {:cycle, _} -> true
      _ -> false
    end)
  end

  def part_2(input) do
    part_2_brute_force(input)
  end
end
