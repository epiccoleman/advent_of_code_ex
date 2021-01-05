  defmodule Day20 do
    alias Day20.Grid

    @monster_grid [
      "..................#..",
      "#....##....##....###.",
      ".#..#..#..#..#..#...."
    ] |> Grid.from_strs()

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

    def assemble_image(tile_map) do
      neighbor_map = neighbor_map(tile_map)
      corners = corners(neighbor_map)

      {start_corner_id, _neighbors} = corners |> hd
      new_corner = reorient_start_corner(tile_map, start_corner_id, neighbor_map)

      ready_tile_map = Map.put(tile_map, start_corner_id, new_corner)

      tile_layout = %{} |> Map.put({0, 0}, start_corner_id)


      img_size = ceil(:math.sqrt(Enum.count(tile_map)) - 1)

      # first populate the top row
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

      # next use the same logic to populate the left column
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

      # now go down the y axis and fill in each row
      Enum.reduce(1..img_size, layout_state, fn y, state_outer ->
        Enum.reduce(1..img_size, state_outer, fn x, state ->
          id_of_left_neighbor = state.layout[{x-1, y}]
          edge_to_match = Grid.right_edge(state.map[id_of_left_neighbor])
          right_neighbor_id = get_neighbor_in_direction(state.map, id_of_left_neighbor, neighbor_map, :right)
          right_neighbor_grid = Map.get(state.map, right_neighbor_id)
          reoriented = Grid.orient_edge_to_direction(right_neighbor_grid, edge_to_match, :left)

          new_layout = state.layout |> Map.put({x, y}, right_neighbor_id)
          new_map = state.map |> Map.put(right_neighbor_id, reoriented)

          %{layout: new_layout, map: new_map, img_size: img_size}
        end)
      end)
    end

    def monster_at_location?(grid, {x, y}) do
      monster_positions =
        @monster_grid.grid_map
        |> Enum.filter(fn {_pos, c} -> c == "#" end)
        |> Enum.map(fn {pos, _} -> pos end)


      Enum.all?(monster_positions, fn {offset_x, offset_y} ->
        Grid.at(grid, {x + offset_x, y + offset_y}) == "#"
      end)
    end

    def trim_tiles(tile_map) do
        tile_map
        |> Enum.map(fn {id, grid} -> {id, Grid.trim_edges(grid)} end)
        |> Enum.into(%{})
    end

    def process_image_for_monster_detection(%{layout: img_layout, map: tile_map, img_size: img_size} = _image) do
      # trim the edges of all the tiles, then stitch them together
      trimmed_tiles = trim_tiles(tile_map)

        #  need all the rows, fuckin headache
      Enum.reduce(0..img_size, [], fn y, tl_rows_acc ->
        # all tiles for this row
        new_rows = Enum.map(0..img_size, fn x ->
            id = img_layout[{x, y}]
            Map.get(trimmed_tiles, id)
          end)
        |> Enum.reduce([], fn tile, acc ->
          Grid.append_grid(acc, tile)
        end)
        |> Grid.rows()

        tl_rows_acc ++ new_rows
      end)
      |> Grid.from_rows()
    end

    def detect_monsters(image_grid) do
      for x <- 0..(image_grid.x_max - @monster_grid.x_max),
          y <- 0..(image_grid.y_max - @monster_grid.y_max) do
            if monster_at_location?(image_grid, {x,y}) do
              {x,y}
            end
      end
      |> Enum.reject(&is_nil/1)
    end

      # for each of the possible orientations of the image, slide the monster detector around
    def detect_monsters_all(image_grid)do
      image_grid
      |> Grid.all_orientations()
      |> Enum.map(&detect_monsters/1)
      |> Enum.reject(&Enum.empty?/1)
      |> List.flatten()
    end

    def part_1(input) do
      input
      |> input_to_map()
      |> neighbor_map()
      |> corners()
      |> Enum.reduce(1, fn {id, _},acc -> acc * id end )
    end

    def part_2(input) do
      image = input
      |> input_to_map()
      |> assemble_image()
      |> process_image_for_monster_detection()

      monster_count =
        image
        |> detect_monsters_all()
        |> Enum.count()

      tiles_in_a_monster = @monster_grid.grid_map |> Enum.count(fn {_pos, c} -> c == "#" end)
      total_monster_tiles = tiles_in_a_monster * monster_count

      hash_tiles = image.grid_map |> Enum.count(fn {_pos, c} -> c == "#" end)

      hash_tiles - total_monster_tiles
    end
  end
