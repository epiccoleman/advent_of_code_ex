defmodule Aoc2021.Day15.Old do
  alias AocUtils.Grid2D, as: Grid
  @doc """
  This is the first and most naive implementation of the algorithm that I wrote. The first performance issues identified were
  using `in` to check membership. It is wickedly slow on the 500x500 grid.
  """
  def dijkstra_1(grid, start_pos, end_pos) do
    # this function head is for the first time you call the thing
    distances = Enum.map(grid, fn {pos, _} ->
      {pos, 10_000_000_000}
    end)
    |> Map.new
    |> Map.put(start_pos, 0)

    unvisited =
      Grid.to_list(grid)
      |> Enum.map(fn {pos, _} -> pos end)
      |> MapSet.new

    state = %{
      distances: distances,
      prev: %{},
      unvisited: unvisited,
      current: start_pos
    }

    dijkstra_1(grid, start_pos, end_pos, state)
  end

  def dijkstra_1(grid, start_pos, end_pos, %{distances: distances, prev: prev, current: current, unvisited: unvisited}) do
    # mark the current node as visited
    new_unvisited = MapSet.delete(unvisited, current)

    # get the current node's neighbors, and remove any which we've already visited
    unvisited_neighbors =
      Grid.edge_neighbor_locs(grid, current)
      |> Enum.filter(fn loc -> loc in unvisited end)

    current_node_weight = Map.get(distances, current)

    # calculate the distance through the current node to each of its neighbors. if this distance is shorter than the previous distance on hand,
    # we will update the distances map with the new distance, and set the current node as the neighbor's prev.
    cells_with_new_distances =
      Enum.map(unvisited_neighbors, fn neighbor_loc ->
        neighbor_weight = Grid.at!(grid, neighbor_loc)
        distance_through_current = neighbor_weight + current_node_weight

        if distance_through_current < Map.get(distances, neighbor_loc) do
          {neighbor_loc, distance_through_current}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    # this reduce updates the distances and prev maps with any new stuff
    {new_distances, new_prev} = Enum.reduce(cells_with_new_distances, {distances, prev}, fn {loc, new_distance}, {distance_acc, prev_acc} ->
      new_distance_acc = Map.put(distance_acc, loc, new_distance)
      new_prev_acc = Map.put(prev_acc, loc, current)

      {new_distance_acc, new_prev_acc}
    end)

    # pick a new current by choosing the node with the least distance from the set of unvisited nodes:
    {new_current, _} =
      Enum.filter(distances, fn {loc, _distance} ->
        loc in unvisited
      end)
      |> Enum.min_by(fn {_loc, distance} -> distance end)

    new_state = %{
      distances: new_distances,
      prev: new_prev,
      current: new_current,
      unvisited: new_unvisited
    }

    if new_current == end_pos do
      new_state
    else
      dijkstra_1(grid, start_pos, end_pos, new_state)
    end
  end

################################################################################
  @doc """
  This is version 2, which used `MapSet.member?` in place of `in`, but which had some other key issues - most critically, I think, that
  the code which calculates the new current was using `distances` instead of `new_distances`, which sort of breaks part of the algorithm.
  We need to use `new_distances` because otherwise we don't stick to the path we're on as closely, resulting in a lot of unnecessary calls
  to djikstra.
  """
  def dijkstra_2(grid, start_pos, end_pos) do
    # this function head is for the first time you call the thing
    distances = Enum.map(grid, fn {pos, _} ->
      {pos, 10_000_000_000}
    end)
    |> Map.new
    |> Map.put(start_pos, 0)

    unvisited =
      Grid.to_list(grid)
      |> Enum.map(fn {pos, _} -> pos end)
      |> MapSet.new

    state = %{
      distances: distances,
      prev: %{},
      unvisited: unvisited,
      current: start_pos
    }

    dijkstra_2(grid, start_pos, end_pos, state)
  end

  def dijkstra_2(grid, start_pos, end_pos, %{distances: distances, prev: prev, current: current, unvisited: unvisited}) do
    # mark the current node as visited
    new_unvisited = MapSet.delete(unvisited, current)

    # get the current node's neighbors, and remove any which we've already visited
    unvisited_neighbors =
      Grid.edge_neighbor_locs(grid, current)
      |> Enum.filter(fn loc -> MapSet.member?(new_unvisited, loc) end)

    current_node_weight = Map.get(distances, current)

    # calculate the distance through the current node to each of its neighbors. if this distance is shorter than the previous distance on hand,
    # we will update the distances map with the new distance, and set the current node as the neighbor's prev.
    cells_with_new_distances =
      Enum.map(unvisited_neighbors, fn neighbor_loc ->
        neighbor_weight = Grid.at!(grid, neighbor_loc)
        distance_through_current = neighbor_weight + current_node_weight

        if distance_through_current < Map.get(distances, neighbor_loc) do
          {neighbor_loc, distance_through_current}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    # this reduce updates the distances and prev maps with any new stuff
    {new_distances, new_prev} = Enum.reduce(cells_with_new_distances, {distances, prev}, fn {loc, new_distance}, {distance_acc, prev_acc} ->
      new_distance_acc = Map.put(distance_acc, loc, new_distance)
      new_prev_acc = Map.put(prev_acc, loc, current)

      {new_distance_acc, new_prev_acc}
    end)

    # pick a new current by choosing the node with the least distance from the set of unvisited nodes:
    {new_current, _} =
      Enum.filter(distances, fn {loc, _distance} ->
        MapSet.member?(new_unvisited, loc)
      end)
      |> Enum.min_by(fn {_loc, distance} -> distance end)

    new_state = %{
      distances: new_distances,
      prev: new_prev,
      current: new_current,
      unvisited: new_unvisited
    }

    if new_current == end_pos do
      new_state
    else
      dijkstra_2(grid, start_pos, end_pos, new_state)
    end
  end

################################################################################
  @doc """
  In version 3, I updated that final filtering to look at new_distances instead. I think this is one of the bigger boosts.
  The final code also optimizes the selection of a new node by swapping out the `filter |> min_by` for a reduce, so that we only
  iterate over `distances` (which has as many elements as the grid) one time.
  """
  def dijkstra_3(grid, start_pos, end_pos) do
    # this function head is for the first time you call the thing
    distances = Enum.map(grid, fn {pos, _} ->
      {pos, 10_000_000_000}
    end)
    |> Map.new
    |> Map.put(start_pos, 0)

    unvisited =
      Grid.to_list(grid)
      |> Enum.map(fn {pos, _} -> pos end)
      |> MapSet.new

    state = %{
      distances: distances,
      prev: %{},
      unvisited: unvisited,
      current: start_pos
    }

    dijkstra_3(grid, start_pos, end_pos, state)
  end

  def dijkstra_3(grid, start_pos, end_pos, %{distances: distances, prev: prev, current: current, unvisited: unvisited}) do
    # mark the current node as visited
    new_unvisited = MapSet.delete(unvisited, current)

    # get the current node's neighbors, and remove any which we've already visited
    unvisited_neighbors =
      Grid.edge_neighbor_locs(grid, current)
      |> Enum.filter(fn loc -> MapSet.member?(new_unvisited, loc) end)

    current_node_weight = Map.get(distances, current)

    # calculate the distance through the current node to each of its neighbors. if this distance is shorter than the previous distance on hand,
    # we will update the distances map with the new distance, and set the current node as the neighbor's prev.
    cells_with_new_distances =
      Enum.map(unvisited_neighbors, fn neighbor_loc ->
        neighbor_weight = Grid.at!(grid, neighbor_loc)
        distance_through_current = neighbor_weight + current_node_weight

        if distance_through_current < Map.get(distances, neighbor_loc) do
          {neighbor_loc, distance_through_current}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    # this reduce updates the distances and prev maps with any new stuff
    {new_distances, new_prev} = Enum.reduce(cells_with_new_distances, {distances, prev}, fn {loc, new_distance}, {distance_acc, prev_acc} ->
      new_distance_acc = Map.put(distance_acc, loc, new_distance)
      new_prev_acc = Map.put(prev_acc, loc, current)

      {new_distance_acc, new_prev_acc}
    end)

    # pick a new current by choosing the node with the least distance from the set of unvisited nodes:
    {new_current, _} =
      Enum.filter(new_distances, fn {loc, _distance} ->
        MapSet.member?(new_unvisited, loc)
      end)
      |> Enum.min_by(fn {_loc, distance} -> distance end)

    new_state = %{
      distances: new_distances,
      prev: new_prev,
      current: new_current,
      unvisited: new_unvisited
    }

    if new_current == end_pos do
      new_state
    else
      dijkstra_3(grid, start_pos, end_pos, new_state)
    end
  end

 ################################################################################

  def dijkstra_4(grid, start_pos, end_pos) do
    # this function head is for the first time you call the thing
    distances = Enum.map(grid, fn {pos, _} ->
      {pos, 10_000_000_000}
    end)
    |> Map.new
    |> Map.put(start_pos, 0)

    unvisited =
      Grid.to_list(grid)
      |> Enum.map(fn {pos, _} -> pos end)
      |> MapSet.new

    state = %{
      distances: distances,
      prev: %{},
      unvisited: unvisited,
      current: start_pos
    }

    dijkstra_4(grid, start_pos, end_pos, state)
  end

  def dijkstra_4(grid, start_pos, end_pos, %{distances: distances, prev: prev, current: current, unvisited: unvisited}) do
    # mark the current node as visited
    # IO.puts("running for #{inspect(current)}")
    new_unvisited = MapSet.delete(unvisited, current)

    # get the current node's neighbors, and remove any which we've already visited
    unvisited_neighbors =
      Grid.edge_neighbor_locs(grid, current)
      |> Enum.filter(fn loc -> MapSet.member?(new_unvisited, loc) end)

    current_node_weight = Map.get(distances, current)

    # calculate the distance through the current node to each of its neighbors. if this distance is shorter than the previous distance on hand,
    # we will update the distances map with the new distance, and set the current node as the neighbor's prev.
    cells_with_new_distances =
      Enum.map(unvisited_neighbors, fn neighbor_loc ->
        neighbor_weight = Grid.at(grid, neighbor_loc)
        distance_through_current = neighbor_weight + current_node_weight

        if distance_through_current < Map.get(distances, neighbor_loc) do
          {neighbor_loc, distance_through_current}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    # this reduce updates the distances and prev maps with any new stuff
    {new_distances, new_prev} = Enum.reduce(cells_with_new_distances, {distances, prev}, fn {loc, new_distance}, {distance_acc, prev_acc} ->
      new_distance_acc = Map.put(distance_acc, loc, new_distance)
      new_prev_acc = Map.put(prev_acc, loc, current)

      {new_distance_acc, new_prev_acc}
    end)

    {new_current, _} = Enum.reduce(new_distances, {:foo, 1_000_000_000_000}, fn {pos, distance}, {_, acc_distance} = acc ->
      if distance < acc_distance and MapSet.member?(new_unvisited, pos) do
        {pos, distance}
      else
        acc
      end
    end)

    new_state = %{
      distances: new_distances,
      prev: new_prev,
      current: new_current,
      unvisited: new_unvisited
    }

    if new_current == end_pos do
      new_state
    else
      dijkstra_4(grid, start_pos, end_pos, new_state)
    end
  end

end
