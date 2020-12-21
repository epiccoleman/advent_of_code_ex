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

    end

    def get_neighbor(tile_map, tile_id, direction) do

    end

    def assemble_image(tile_map) do
    end

    def detect_monsters(image_grid) do

    end

    def part_1(input) do
      tile_map = input
      |> input_to_map()

      all_edges =
        tile_map
        |> Enum.map(fn {id, grid} -> {id, enumerate_possible_edges(grid)} end)

      all_edges
      |> Enum.map(fn {id, tile_edges} ->
        match_count = Enum.filter(all_edges, fn {other_id, other_edges} ->
          buddies = MapSet.intersection(tile_edges, other_edges)
          |> MapSet.size()

          other_id != id and buddies > 0
        end)
        |> Enum.count()

        {id, match_count}
      end)
      |> Enum.filter(fn {id, c} -> c <= 2 end)
      |> Enum.reduce(1, fn {id, _},acc -> acc * id end )
    end

    def part_2(input) do
      input
      # assemble the image
      #
    end
  end
