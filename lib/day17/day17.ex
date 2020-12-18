defmodule Day17 do
  def populate_initial_state(input) do
    grid = input |> Enum.map(&String.graphemes/1)
    y_max = length(grid) - 1
    x_max = length(Enum.at(grid, 0)) - 1

    cubes =
      for x <- 0..x_max,
          y <- 0..y_max,
          z <- [0] do
        state = grid |> Enum.at(y) |> Enum.at(x) == "#"
        {{x, y, z}, state}
      end
      |> Enum.into(%{})

    universe_size = %{y_min: 0, y_max: y_max, x_min: 0, x_max: x_max, z_min: 0, z_max: 0}

    %{cubes: cubes, universe_size: universe_size}
  end

  def enumerate_cube_neighbors({x, y, z} = cube_pos) do
    for n_x <- (x - 1)..(x + 1),
        n_y <- (y - 1)..(y + 1),
        n_z <- (z - 1)..(z + 1) do
      {n_x, n_y, n_z}
    end
    |> Enum.reject(&(&1 == cube_pos))
  end

  def count_active_neighbors(pos, cubes) do
    pos
    |> enumerate_cube_neighbors()
    |> Enum.count(fn pos -> Map.get(cubes, pos) end)
  end

  def expand_universe(%{cubes: cubes, universe_size: universe_size}) do
    new_size = %{
      x_min: universe_size.x_min - 1,
      x_max: universe_size.x_max + 1,
      y_min: universe_size.y_min - 1,
      y_max: universe_size.y_max + 1,
      z_min: universe_size.z_min - 1,
      z_max: universe_size.z_max + 1
    }

    new_cubes =
      for x <- new_size.x_min..new_size.x_max,
          y <- new_size.y_min..new_size.y_max,
          z <- new_size.z_min..new_size.z_max do
        {x, y, z}
      end
      |> Enum.map(fn pos -> {pos, Map.get(cubes, pos)} end)
      |> Enum.into(%{})

    %{universe_size: new_size, cubes: new_cubes}
  end

  def next_cube_state(pos, cubes) do
    current_state = Map.get(cubes, pos)
    neighbor_count = count_active_neighbors(pos, cubes)

    cond do
      !!current_state and neighbor_count in 2..3 -> true
      not (!!current_state) and neighbor_count == 3 -> true
      true -> false
    end
  end

  def next_state(state) do
    exp_state = expand_universe(state)

    new_cubes =
      Enum.reduce(Map.keys(exp_state.cubes), %{}, fn pos, acc ->
        acc |> Map.put(pos, next_cube_state(pos, exp_state.cubes))
      end)

    %{universe_size: exp_state.universe_size, cubes: new_cubes}
  end

  def run_simulation(input, iterations) do
    state = populate_initial_state(input)

    Enum.reduce(1..iterations, state, fn _, acc ->
      next_state(acc)
    end)
  end

  def part_1(input) do
    input
    |> run_simulation(6)
    |> Map.get(:cubes)
    |> Enum.count(fn {_pos, state} -> state end)
  end

  ###
  def populate_initial_state_4d(input) do
    grid = input |> Enum.map(&String.graphemes/1)
    y_max = length(grid) - 1
    x_max = length(Enum.at(grid, 0)) - 1

    cubes =
      for x <- 0..x_max,
          y <- 0..y_max,
          z <- [0],
          w <- [0] do
        state = grid |> Enum.at(y) |> Enum.at(x) == "#"
        {{x, y, z, w}, state}
      end
      |> Enum.into(%{})

    universe_size = %{
      y_min: 0,
      y_max: y_max,
      x_min: 0,
      x_max: x_max,
      z_min: 0,
      z_max: 0,
      w_min: 0,
      w_max: 0
    }

    %{cubes: cubes, universe_size: universe_size}
  end

  def enumerate_cube_neighbors_4d({x, y, z, w} = cube_pos) do
    for n_x <- (x - 1)..(x + 1),
        n_y <- (y - 1)..(y + 1),
        n_z <- (z - 1)..(z + 1),
        n_w <- (w - 1)..(w + 1) do
      {n_x, n_y, n_z, n_w}
    end
    |> Enum.reject(&(&1 == cube_pos))
  end

  def count_active_neighbors_4d(pos, cubes) do
    pos
    |> enumerate_cube_neighbors_4d()
    |> Enum.count(fn pos -> Map.get(cubes, pos) end)
  end

  def expand_universe_4d(%{cubes: cubes, universe_size: universe_size}) do
    new_size = %{
      x_min: universe_size.x_min - 1,
      x_max: universe_size.x_max + 1,
      y_min: universe_size.y_min - 1,
      y_max: universe_size.y_max + 1,
      z_min: universe_size.z_min - 1,
      z_max: universe_size.z_max + 1,
      w_min: universe_size.w_min - 1,
      w_max: universe_size.w_max + 1
    }

    new_cubes =
      for x <- new_size.x_min..new_size.x_max,
          y <- new_size.y_min..new_size.y_max,
          z <- new_size.z_min..new_size.z_max,
          w <- new_size.w_min..new_size.w_max do
        {x, y, z, w}
      end
      |> Enum.map(fn pos -> {pos, Map.get(cubes, pos)} end)
      |> Enum.into(%{})

    %{universe_size: new_size, cubes: new_cubes}
  end

  def next_cube_state_4d(pos, cubes) do
    current_state = Map.get(cubes, pos)
    neighbor_count = count_active_neighbors_4d(pos, cubes)

    cond do
      !!current_state and neighbor_count in 2..3 -> true
      not (!!current_state) and neighbor_count == 3 -> true
      true -> false
    end
  end

  def next_state_4d(state) do
    exp_state = expand_universe_4d(state)

    new_cubes =
      Enum.reduce(Map.keys(exp_state.cubes), %{}, fn pos, acc ->
        acc |> Map.put(pos, next_cube_state_4d(pos, exp_state.cubes))
      end)

    %{universe_size: exp_state.universe_size, cubes: new_cubes}
  end

  def run_simulation_4d(input, iterations) do
    state = populate_initial_state_4d(input)

    Enum.reduce(1..iterations, state, fn _, acc ->
      next_state_4d(acc)
    end)
  end

  def part_2(input) do
    input
    |> run_simulation_4d(6)
    |> Map.get(:cubes)
    |> Enum.count(fn {_pos, state} -> state end)
  end
end
