
  defmodule Aoc2021.Day15 do
    alias AocUtils.Grid2D, as: Grid
    def input_to_grid(input) do
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn row ->
        Enum.map(row, &String.to_integer/1)
      end)
      |> Grid.from_rows()
    end

    def dijkstra(grid, start_pos, end_pos) do
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

      dijkstra(grid, start_pos, end_pos, state)
    end

    def dijkstra(grid, start_pos, end_pos, %{distances: distances, prev: prev, current: current, unvisited: unvisited}) do
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

      # {new_current, _} = Enum.reduce(new_distances, {:foo, 1_000_000_000_000}, fn {pos, distance}, {_, acc_distance} = acc ->
      #   if distance < acc_distance and MapSet.member?(new_unvisited, pos) do
      #     {pos, distance}
      #   else
      #     acc
      #   end
      # end)

      {new_current, _} = Enum.reduce(new_unvisited, {:foo, 1_000_000_000}, fn pos, {_, acc_distance} = acc ->
        new_distance = Map.get(new_distances, pos)

        if new_distance < acc_distance do
          {pos, new_distance}
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
        dijkstra(grid, start_pos, end_pos, new_state)
      end
    end

    def assemble_megagrid(grid) do
      base_grid_tile = grid

      top_row = Enum.reduce(1..4, grid, fn n, acc ->
        new_tile = increment_grid_risk(base_grid_tile, n)

        merge_loc = { acc.x_max + 1, 0 }

        Grid.merge(acc, new_tile, merge_loc, fn _, _, v -> v end)
      end)

      megagrid = Enum.reduce(1..4, top_row, fn n, acc ->
        new_tile = increment_grid_risk(top_row, n)

        merge_loc = { 0, acc.y_max + 1 }

        Grid.merge(acc, new_tile, merge_loc, fn _, _, v -> v end)
      end)

      IO.puts("megagrid complete")
      megagrid
    end

    def increment_grid_risk(grid, n \\ 1) do
      Grid.map(grid, fn {_, v} ->
        new = v + n

        if new > 9 do
          new - 9
        else
          new
        end
      end)
    end

    def part_1(input) do
      grid = input_to_grid(input)

      result = dijkstra(grid, {0,0}, {grid.x_max, grid.y_max})

      Map.get(result.distances, {grid.x_max, grid.y_max})
    end

    def part_2(input) do
      grid =
        input_to_grid(input)
        |> assemble_megagrid()

      result = dijkstra(grid, {0,0}, {grid.x_max, grid.y_max})

      Map.get(result.distances, {grid.x_max, grid.y_max})
    end
  end
