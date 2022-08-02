defmodule AocUtils.Grid2D.Transformations do
  @moduledoc """
  Defines a number of functions which perform various transformations on the Grid2D.
  """

  alias AocUtils.Grid2D

  @doc """
  Given a Grid, returns that grid with values flipped (mirrored) horizontally.
  """
  def flip_horiz(grid) do
    grid
    |> Grid2D.rows
    |> Enum.map(&Enum.reverse/1)
    |> Grid2D.from_rows()
  end

  @doc """
  Given a Grid, returns that grid with values flipped (mirrored) vertically.
  """
  def flip_vert(grid) do
    grid
    |> Grid2D.cols
    |> Enum.map(&Enum.reverse/1)
    |> Grid2D.from_cols()
  end

  @doc """
  Given a Grid, rotates it by 90 degrees.
  """
  def rotate(grid) do
    grid
    |> flip_vert()
    |> Grid2D.cols
    |> Grid2D.from_rows()
  end

  @doc """
  Given a Grid, rotates it by 180 degrees.
  """
  def rotate180(grid) do
    grid
    |> rotate()
    |> rotate()
  end

  @doc """
  Given a Grid, rotates it by 270 degrees.
  """
  def rotate270(grid) do
    grid
    |> rotate()
    |> rotate()
    |> rotate()
  end

  @doc """
  Returns the column at the leftmost edge of the grid, as a list of cell values.
  """
  def left_edge(grid) do
    Grid2D.col(grid, 0)
  end

  @doc """
  Returns the column at the rightmost edge of the grid, as a list of cell values.
  """
  def right_edge(grid) do
    Grid2D.col(grid, grid.x_max)
  end

  @doc """
  Returns the topmost row of the grid as a list of cell values.
  """
  def top_edge(grid) do
    Grid2D.row(grid, 0)
  end

  @doc """
  Returns the lowest row of the grid as a list of cell values.
  """
  def bottom_edge(grid) do
    Grid2D.row(grid, grid.y_max)
  end

  @doc """
  Removes all the cells on the edges of the grid.
  """
  def trim_edges(grid) do
    new_rows =
      Grid2D.rows(grid)
      |> List.delete_at(grid.y_max)
      |> List.delete_at(0)
      |> Enum.map(fn row -> row |> List.delete_at(grid.x_max) |> List.delete_at(0) end)

    Grid2D.from_rows(new_rows)
  end

  @doc """
  Given a grid, and a list of values representing one edge of the grid, reorients the grid so that that edge is
  on the top.

  Returns nil if the given edge is not found in the grid, so use this carefully.
  """
  def orient_edge_top(grid, edge) do
    grid
    |> all_orientations()
    |> Enum.find(fn grid -> top_edge(grid) == edge end)
  end

  @doc """
  Given a grid, and a list of values representing one edge of the grid, and a direction,
  reorients the grid so that that given edge is on the given side.

  Valid directions are: :top, :bottom, :right, :left.

  Returns nil if the given edge is not found in the grid, so use this carefully.
  """
  def orient_edge_to_direction(grid, edge, direction) do
    edge_fn = case direction do
      :top -> &top_edge/1
      :bottom -> &bottom_edge/1
      :right -> &right_edge/1
      :left -> &left_edge/1
    end

    grid
    |> all_orientations()
    |> Enum.find(fn grid -> edge_fn.(grid) == edge end)
  end

    @doc """
  Returns a MapSet containing all possible rotations and mirrorings of the given Grid.
  """
  def all_orientations(grid) do
    # only 8 of these are unique but I cbf to figure out which right now, so we'll let MapSet do the work.
    MapSet.new([
      grid,
      rotate(grid),
      rotate180(grid),
      rotate270(grid),
      flip_vert(grid),
      rotate(flip_vert(grid)),
      rotate180(flip_vert(grid)),
      rotate270(flip_vert(grid)),
      flip_horiz(grid),
      rotate(flip_horiz(grid)),
      rotate180(flip_horiz(grid)),
      rotate270(flip_horiz(grid)),
    ])
    |> MapSet.to_list()
  end
end
