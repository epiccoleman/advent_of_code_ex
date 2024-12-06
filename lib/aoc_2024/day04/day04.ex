defmodule Aoc2024.Day04 do
  alias AocUtils.Grid2D

  @xmas_diag [
               "X...",
               ".M..",
               "..A.",
               "...S"
             ]
             |> Grid2D.from_strs(ignore: ".")

  @x_mas_pattern [
                   "M.S",
                   ".A.",
                   "M.S"
                 ]
                 |> Grid2D.from_strs(ignore: ".")

  def count_xmas_horiz(grid = %Grid2D{}) do
    grid
    |> Grid2D.to_strs()
    |> Enum.map(fn row_str ->
      forward_count = Enum.count(Regex.scan(~r/XMAS/, row_str))
      reverse_count = Enum.count(Regex.scan(~r/SAMX/, row_str))
      forward_count + reverse_count
    end)
    |> Enum.sum()
  end

  def count_xmas_vert(grid = %Grid2D{}) do
    grid
    |> Grid2D.rotate()
    |> count_xmas_horiz()
  end

  def count_xmas_diagonal(grid = %Grid2D{}) do
    patterns = [
      @xmas_diag,
      Grid2D.rotate(@xmas_diag),
      Grid2D.rotate180(@xmas_diag),
      Grid2D.rotate270(@xmas_diag)
    ]

    Enum.map(patterns, fn pattern ->
      Grid2D.Patterns.count_pattern_occurences(grid, pattern)
    end)
    |> Enum.sum()
  end

  def count_xmases(grid) do
    count_xmas_horiz(grid) + count_xmas_vert(grid) + count_xmas_diagonal(grid)
  end

  @doc """
  ha ha.
  """
  def count_x_mas(grid) do
    patterns = [
      @x_mas_pattern,
      Grid2D.rotate(@x_mas_pattern),
      Grid2D.rotate180(@x_mas_pattern),
      Grid2D.rotate270(@x_mas_pattern)
    ]

    Enum.map(patterns, fn pattern ->
      Grid2D.Patterns.count_pattern_occurences(grid, pattern)
    end)
    |> Enum.sum()
  end

  def part_1(input) do
    input
    |> Grid2D.from_strs()
    |> count_xmases()
  end

  def part_2(input) do
    input
    |> Grid2D.from_strs()
    |> count_x_mas()
  end
end
