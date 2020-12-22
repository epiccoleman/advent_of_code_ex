  defmodule Day20 do
    alias Day20.Grid

    def input_str_to_map_entry(input_str) do
      # takes a string like this:
      # "Tile 3469:\n.##..#.#.#\n##..#...##\n...#..##.#\n....#.#..#\n#..#.##...\n.#.##.#.##\n..#.#.....\n..###.#..#\n#.##.#...#\n....#...##"

      [ tile_str | grid_strs ] = input_str |> String.split("\n")
      tile_id = Regex.named_captures(~r"(?<id>\d+)", tile_str) |> Map.get("id") |> String.to_integer()
      grid = grid_strs |> Grid.from_strs()

      {tile_id, grid}
    end

    def input_to_map(raw_input) do
      raw_input
      |> String.split("\n\n")
      |> Enum.map(&input_str_to_map_entry/1)
      |> Enum.into(%{})
    end

    def enumerate_possible_edges(grid) do
      left_edge = Grid.col(grid, 0)
      right_edge = Grid.col(grid, grid.x_max)
      top_edge = Grid.row(grid, 0)
      bottom_edge = Grid.row(grid, grid.y_max)

      MapSet.new([
        left_edge,
        Enum.reverse(left_edge),
        right_edge,
        Enum.reverse(right_edge),
        top_edge,
        Enum.reverse(top_edge),
        bottom_edge,
        Enum.reverse(bottom_edge),
      ])
    end
    def get_neighbors(tile_map, tile_id) do
      current_grid = tile_map[tile_id]
      edges = enumerate_possible_edges(current_grid)

      tile_map
      |> Enum.filter(fn {other_id, other_grid} ->
        other_edges = enumerate_possible_edges(other_grid)
        Enum.count(MapSet.intersection(edges, other_edges)) > 0 and other_id != tile_id
      end)
      |> Enum.map(fn {id, _} -> id end)
    end

    # def get_neighbor(tile_map, tile_id, direction) do

    # end

    def neighbor_map(tile_map) do
      tile_map
      |> Enum.map(fn {id, _grid} -> {id, get_neighbors(tile_map, id)} end)
      |> Enum.into(%{})
    end

    def corners(neighbor_map) do
      neighbor_map
      |> Enum.filter(fn {_id, neighbors} -> length(neighbors) == 2 end)
    end

    def assemble_image(tile_map) do
      neighbor_map = neighbor_map(tile_map)
      corners = corners(neighbor_map)

      {start_corner_id, _neighbors} = corners |> hd
      new_corner = reorient_start_corner(tile_map, start_corner_id, neighbor_map)

      ready_tile_map = Map.put(tile_map, start_corner_id, new_corner)

      tile_layout = %{} |> Map.put({0, 0}, start_corner_id)


      # hard coding image size for now
      img_size = ceil(:math.sqrt(Enum.count(tile_map)) - 1)

      layout_state = Enum.reduce(1..img_size, %{layout: tile_layout, map: ready_tile_map}, fn n, state ->
        id_of_left_neighbor = state.layout[{n-1, 0}]
        edge_to_match = Grid.right_edge(state.map[id_of_left_neighbor])
        right_neighbor_id = get_neighbor_in_direction(state.map, id_of_left_neighbor, neighbor_map, :right)
        right_neighbor_grid = Map.get(state.map, right_neighbor_id)
        reoriented = Grid.orient_edge_to_direction(right_neighbor_grid, edge_to_match, :left)

        new_layout = state.layout |> Map.put({n, 0}, right_neighbor_id)
        new_map = state.map |> Map.put(right_neighbor_id, reoriented)

        %{layout: new_layout, map: new_map}
      end)

      layout_state = Enum.reduce(1..img_size, layout_state, fn n, state ->
        id_of_top_neighbor = state.layout[{0, n-1}]
        edge_to_match = Grid.bottom_edge(state.map[id_of_top_neighbor])
        bottom_neighbor_id = get_neighbor_in_direction(state.map, id_of_top_neighbor, neighbor_map, :bottom)
        bottom_neighbor_grid = Map.get(state.map, bottom_neighbor_id)
        reoriented = Grid.orient_edge_to_direction(bottom_neighbor_grid, edge_to_match, :top)

        new_layout = state.layout |> Map.put({0, n}, bottom_neighbor_id)
        new_map = state.map |> Map.put(bottom_neighbor_id, reoriented)

        %{layout: new_layout, map: new_map}
      end)

      Enum.reduce(1..img_size, layout_state, fn y, state_outer ->
        Enum.reduce(1..img_size, state_outer, fn x, state ->
          id_of_left_neighbor = state.layout[{x-1, y}]
          edge_to_match = Grid.right_edge(state.map[id_of_left_neighbor])
          right_neighbor_id = get_neighbor_in_direction(state.map, id_of_left_neighbor, neighbor_map, :right)
          right_neighbor_grid = Map.get(state.map, right_neighbor_id)
          reoriented = Grid.orient_edge_to_direction(right_neighbor_grid, edge_to_match, :left)

          new_layout = state.layout |> Map.put({x, y}, right_neighbor_id)
          new_map = state.map |> Map.put(right_neighbor_id, reoriented)

          %{layout: new_layout, map: new_map}
        end)
      end)
    end

    def reorient_start_corner(tile_map, start_corner_id, neighbor_map) do
      ## give this a corner and it will reorient the corner such that it has
      ## neighbors to the right and down. we only need to do this kinda thing on the first corner i think.
      corner = tile_map[start_corner_id]

      {new_grid, _ } = Grid.all_orientations(corner)
      |> Enum.map(fn grid ->
        modified_tile_map = Map.put(tile_map, start_corner_id, grid)
         {grid,
         (get_neighbor_in_direction(modified_tile_map, start_corner_id, neighbor_map, :right) != nil and
         get_neighbor_in_direction(modified_tile_map, start_corner_id, neighbor_map, :bottom) != nil)}
      end)
      |> Enum.filter(fn {grid, had_right_and_down_neighbors?} -> had_right_and_down_neighbors? end)
      |> hd() # there can be more than one, we can pick whatever

      new_grid
    end

    def get_neighbor_in_direction(tile_map, tile_id, neighbor_map, direction) do
      edge_fn = case direction do
        :top -> &Grid.top_edge/1
        :bottom -> &Grid.bottom_edge/1
        :right -> &Grid.right_edge/1
        :left -> &Grid.left_edge/1
      end

      grid = tile_map[tile_id]
      search_edge = edge_fn.(grid)
      possible_neighbors = neighbor_map[tile_id]
      possible_neighbors
      |> Enum.find(fn neighbor_id ->
       neighbor_edges = enumerate_possible_edges(tile_map[neighbor_id])
       search_edge in neighbor_edges
      end)
    end

    def detect_monsters(image_grid) do


    end

    def part_1(input) do
      input
      |> input_to_map()
      |> neighbor_map()
      |> corners()
      |> Enum.reduce(1, fn {id, _},acc -> acc * id end )
    end

    def part_2(input) do
      input
      # assemble the image
      #
    end
  end
