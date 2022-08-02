  defmodule Aoc2021.Day09 do
    @moduledoc """
    --- Day 9: Smoke Basin ---
    These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

    If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

    Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

    2199943210
    3987894921
    9856789892
    8767896789
    9899965678

    Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

    Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

    In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

    The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

    Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?

    --- Part Two ---

    Next, you need to find the largest basins so you know what areas are most important to avoid.

    A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

    The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

    The top-left basin, size 3:

    2199943210
    3987894921
    9856789892
    8767896789
    9899965678

    The top-right basin, size 9:

    2199943210
    3987894921
    9856789892
    8767896789
    9899965678

    The middle basin, size 14:

    2199943210
    3987894921
    9856789892
    8767896789
    9899965678

    The bottom-right basin, size 9:

    2199943210
    3987894921
    9856789892
    8767896789
    9899965678

    Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

    What do you get if you multiply together the sizes of the three largest basins?

    """

    alias AocUtils.Grid2D, as: Grid
    @doc """
    Takes an array of strings representing lines of the puzzle input, and converts to a Grid.
    """
    def input_to_grid(input) do
      input
      |> Enum.map(fn line_str ->
        line_str
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Grid.from_rows
    end

    @doc """
    Given a grid, returns the low points in the grid.
    """
    def find_low_points(%Grid{grid_map: grid_map} = grid) do
      Enum.filter(grid_map, fn {{x, y}, height} ->
        Grid.edge_neighbors(grid, {x, y})
        |> Enum.all?(fn neighbor_height ->
          neighbor_height > height
        end)
      end)
    end

    def risk_level({_loc, height}) do
      height + 1
    end

    def locations_to_search(grid, location, location_we_came_from \\ nil) do
      height_we_came_from = Grid.at(grid, location)

      Grid.edge_neighbor_locs(grid, location)
      |> Enum.filter(fn location ->
        # these are the locations that we want to use for the next 'iteration' in the search.
        # we only want to search
        height = Grid.at(grid, location)

        (location != location_we_came_from
        and height > height_we_came_from
        and height != 9)
      end)
    end

    def find_points_that_flow_into(grid, location, location_we_came_from \\ nil) do
      locs_to_search = locations_to_search(grid, location, location_we_came_from)

      (if Enum.empty?(locs_to_search) do
        [ location, location_we_came_from ]
      else
        Enum.map(locs_to_search, fn new_loc ->
         find_points_that_flow_into(grid, new_loc, location) ++ [location_we_came_from]
        end)
        |> List.flatten()
      end) |> Enum.uniq() |> Enum.reject(&is_nil/1)
    end

    def basin_size(grid, low_point) do
      Enum.count(find_points_that_flow_into(grid, low_point))
    end

    def part_1(input) do
      input
      |> input_to_grid()
      |> find_low_points()
      |> Enum.map(&risk_level/1)
      |> Enum.sum()
    end

    def part_2(input) do
      grid = input_to_grid(input)

      grid
      |> find_low_points()
      |> Enum.map(fn {low_point, _height} ->
        basin_size(grid, low_point)
      end)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.reduce(1, &*/2)
    end
  end
