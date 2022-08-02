defmodule AocUtils.Grid2D.Edges do
  @moduledoc """
  Contains a few functions for accessing and manipulating the edges of Grid2Ds.

  Seems like this is mostly only useful for 2020-20, so these may more logically belong
  in that module. But hey, they work on all Grids, so why not.
  """
  alias AocUtils.Grid2D

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
end
