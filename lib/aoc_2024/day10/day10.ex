defmodule Aoc2024.Day10 do

  alias AocUtils.Grid2D

  def parse_input(input) do
    input
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> Enum.map(&AocUtils.MiscUtils.digitify/1)
    |> Grid2D.from_rows()
  end

  def walk_trailhead(grid, loc) do
    current = Grid2D.at(grid, loc)

    if current == 9 do
      loc
    else
      Grid2D.edge_neighbor_locs(grid, loc)
      |> Enum.filter(fn new_loc -> Grid2D.at(grid, new_loc) == current + 1 end)
      |> Enum.map(fn new_loc ->
        walk_trailhead(grid, new_loc)
      end)
      |> List.flatten()
    end
  end

  def score_trailhead(grid, loc) do
    walk_trailhead(grid, loc)
    |> MapSet.new()
    |> MapSet.size()
  end

  def rate_trailhead(grid, loc) do
    walk_trailhead(grid, loc)
    |> length()
  end

  def part_1(input) do
    grid = parse_input(input)

    Grid2D.matching_locs(grid, 0)
    |> Enum.map(fn trailhead_loc ->
      score_trailhead(grid, trailhead_loc)
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    grid = parse_input(input)

    Grid2D.matching_locs(grid, 0)
    |> Enum.map(fn trailhead_loc ->
      rate_trailhead(grid, trailhead_loc)
    end)
    |> Enum.sum()
  end
end
