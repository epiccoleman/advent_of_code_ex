defmodule AocUtils.Grid2D.Transformations do
  @moduledoc """
  Defines a number of functions which perform various transformations on the Grid2D.
  """

  alias AocUtils.Grid2D
  alias AocUtils.Grid2D.Edges

  @doc """
  Given a Grid, returns that grid with values flipped (mirrored) horizontally.
  """
  def flip_horiz(%Grid2D{x_max: x_max, x_min: x_min} = grid) do
    midpoint = (( x_max + x_min ) / 2)

    new_grid_map =
      Grid2D.to_list(grid)
      |> Enum.map(fn {{x, y}, v} ->
        distance_to_midpoint = midpoint - x
        new_x = trunc(x + (2 * distance_to_midpoint))

        {{new_x, y}, v}
      end)
      |> Map.new()

      %Grid2D{ grid | grid_map: new_grid_map }
  end

  @doc """
  Given a Grid, returns that grid with values flipped (mirrored) vertically.
  """
  def flip_vert(grid) do
    grid
    |> Grid2D.cols()
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
  Given a grid, and a list of values representing one edge of the grid, reorients the grid so that that edge is
  on the top.

  Returns nil if the given edge is not found in the grid, so use this carefully.
  """
  def orient_edge_top(grid, edge) do
    grid
    |> all_orientations()
    |> Enum.find(fn grid -> Edges.top_edge(grid) == edge end)
  end

  @doc """
  Given a grid, and a list of values representing one edge of the grid, and a direction,
  reorients the grid so that that given edge is on the given side.

  Valid directions are: :top, :bottom, :right, :left.

  Returns nil if the given edge is not found in the grid, so use this carefully.
  """
  def orient_edge_to_direction(grid, edge, direction) do
    edge_fn = case direction do
      :top -> &Edges.top_edge/1
      :bottom -> &Edges.bottom_edge/1
      :right -> &Edges.right_edge/1
      :left -> &Edges.left_edge/1
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
