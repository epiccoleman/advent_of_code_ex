defmodule Aoc2024.Day08 do
  alias AocUtils.Grid2D

  @doc """
  Returns a list of the unique pairs of elements in the list as tuples. This is probably inefficient.
  """
  def combinations(list) do
    for a <- list, b <- list do
      if(a != b) do
        MapSet.new([a, b])
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
    |> Enum.map(fn set -> MapSet.to_list(set) |> List.to_tuple() end)
  end

  def find_antinodes_for_pair({{x1, y1}, {x2, y2}}) do
    x_dist = abs(x1 - x2)
    y_dist = abs(y1 - y2)

    min_x = min(x1, x2)
    max_x = max(x1, x2)
    min_y = min(y1, y2)
    max_y = max(y1, y2)

    left_x = min_x - x_dist
    right_x = max_x + x_dist
    # low numerically, but high "visually"
    low_y = min_y - y_dist
    # high numerically, but low "visually"
    high_y = max_y + y_dist

    # 4 possible cases - vertical or horiz line, and then pos or neg slope.
    # since this is indexed graphics style, positive slope is a down pointing line, and neg points up
    # the slope determines whether the high y goes with the right x (pos slope) or the left x (neg slope)
    cond do
      y_dist == 0 -> {{left_x, y1}, {right_x, y1}}
      x_dist == 0 -> {{x1, low_y}, {x1, high_y}}
      (y2 - y1) / (x2 - x1) > 0 -> {{left_x, low_y}, {right_x, high_y}}
      (y2 - y1) / (x2 - x1) < 0 -> {{left_x, high_y}, {right_x, low_y}}
    end
  end

  def find_antinodes_on_channel(grid = %Grid2D{}, channel) do
    antennas = Grid2D.matching_locs(grid, channel)

    antennas
    |> combinations()
    |> Enum.map(&find_antinodes_for_pair/1)
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten()
  end

  def part_1(input) do
    grid = Grid2D.from_strs(input, ignore: ["."])

    channels =
      Grid2D.to_list(grid)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.uniq()

    channels
    |> Enum.map(fn channel -> find_antinodes_on_channel(grid, channel) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.filter(fn loc ->
      Grid2D.within_boundaries?(grid, loc)
    end)
    |> Enum.count()
  end

  @doc """
  Permutations of the values in the list. NOTE TO FUTURE SELF: this will not handle duplicate values, so re-use carefully
  """
  def permutations(list) do
    for a <- list, b <- list do
      if a != b do
        [{a, b}, {b, a}]
      end
    end
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  def find_antinodes_for_pair_part2({{x1, y1}, {x2, y2}}, grid) do
    x_dist = x2 - x1
    y_dist = y2 - y1

    Stream.iterate({x1, y1}, fn {x, y} -> {x + x_dist, y + y_dist} end)
    |> Stream.take_while(fn loc -> Grid2D.within_boundaries?(grid, loc) end)
    |> Enum.into([])
  end

  def find_antinodes_on_channel_part2(grid, channel) do
    antennas = Grid2D.matching_locs(grid, channel)

    antennas
    |> permutations()
    |> Enum.map(fn pair ->
      find_antinodes_for_pair_part2(pair, grid)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  def part_2(input) do
    grid = Grid2D.from_strs(input, ignore: ["."])

    channels =
      Grid2D.to_list(grid)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.uniq()

    channels
    |> Enum.map(fn channel -> find_antinodes_on_channel_part2(grid, channel) end)
    |> List.flatten()
    |> Enum.uniq()
    # |> Enum.filter(fn loc ->
    #   Grid2D.within_boundaries?(grid, loc)
    # end)
    |> Enum.count()
  end
end
