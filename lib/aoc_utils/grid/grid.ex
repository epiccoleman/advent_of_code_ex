defmodule AocUtils.Grid2D do
  @moduledoc """
  Defines a data structure for working with a 2-dimensional grid of values.

  Indexed "graphics" style, where the top left corner is 0,0 and indices increase as you move
  right and down.

  It differs somewhat from a "traditional" 2d array in that the implementation is not actually backed by
  arrays, but presents a fairly similar interface. In Elixir it turns out that it is much easier to write
  this kind of data structure as a map where the keys are tuples referring to indices of the grid.

  Grid2Ds can be constructed from a list of lists of values, or, in cases where grid cells contain a single
  character, they can be constructed from a list of strings (which will be split into characters).

  Note: I'd like to write the construction functions (from_rows and from_strs) as "new" and let the
  language choose which one to dispatch based on the type of the argument. I'm not sure how to do this
  right now, so I'll just be explicit about the construction I'm using for now.
  """
  alias AocUtils.Grid2D

  defstruct grid_map: %{}, x_max: 0, y_max: 0

  @doc """
  Produces a grid from a list of strings. Each string in the list represents a row of the grid, and
  each character in the strings represents a single grid cell.

  All strings given in the list must be of the same length.
  """
  def from_strs(strs) do
    grid_chars = strs |> Enum.map(&String.graphemes/1)

    y_max = length(grid_chars) - 1
    x_max = length(Enum.at(grid_chars, 0)) - 1

    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        state = grid_chars |> Enum.at(y) |> Enum.at(x)
        {{x, y}, state}
      end
      |> Enum.into(%{})

    %Grid2D{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

  @doc """
  Produces a grid from a list of lists. Each list in the list represents a row in the grid, and
  each value in a given list represents a column in that row.

  All lists given in the list must be of the same length.
  """
  def from_rows(rows) do
    y_max = length(rows) - 1
    x_max = length(Enum.at(rows, 0)) - 1

    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        state = rows |> Enum.at(y) |> Enum.at(x)
        {{x, y}, state}
      end
      |> Enum.into(%{})

    %Grid2D{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

  @doc """
  Produces a grid from a list of lists. Each list in the list represents a column in the grid, and
  each value in a given list represents a cell in that column.

  All lists given in the list must be of the same length.
  """
  def from_cols(cols) do
    x_max = length(cols) - 1
    y_max = length(Enum.at(cols, 0)) - 1

    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        state = cols |> Enum.at(x) |> Enum.at(y)
        {{x, y}, state}
      end
      |> Enum.into(%{})

    %Grid2D{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

  @doc """
  Converts a Grid to a list of strings, where each string is the concatentation of the
  values in a row of the Grid. Not usable for grids with numberic values in their cells,
  really only useful for debugging the 2020 Day 20 code, so don't use this.
  """
  def to_strs(grid) do
    rows(grid)
    |> Enum.map(&Enum.join/1)
  end

  @doc """
  Converts a Grid to a list of lists, where each of the lists represents the ordered values
  of a row in the Grid.
  """
  def rows(%Grid2D{grid_map: grid_map, x_max: x_max, y_max: y_max}) do
    for y <- 0..y_max do
      for x <- 0..x_max do
        Map.get(grid_map, {x, y})
      end
    end
  end

  @doc """
  Returns the row at the given y value as a list of cell values.
  """
  def row(grid, y) do
    rows(grid)
    |> Enum.at(y)
  end

  @doc """
  Returns the row at the given x value as a list of cell values.
  """
  def col(grid, x) do
    cols(grid)
    |> Enum.at(x)
  end

  @doc """
  Converts a Grid to a list of lists, where each of the lists represents the ordered values
  of a column in the Grid.
  """
  def cols(%Grid2D{grid_map: grid_map, x_max: x_max, y_max: y_max}) do
    for x <- 0..x_max do
      for y <- 0..y_max do
        Map.get(grid_map, {x, y})
      end
    end
  end

  @doc """
  Prints as a Grid all mashed together - not particularly useful outside of Aoc 2020 Day 20 debugging.
  Don't use.
  """
  def print(grid) do
    to_strs(grid)
    |> Enum.map(&IO.puts/1)
  end

  @doc """
  Returns the value of the Grid cell at the given coordinates.
  """
  def at(grid, {x, y}) do
    Map.get(grid.grid_map, {x, y})
  end

  def at(grid, x, y) do
    at(grid, {x, y})
  end

  ## transforms

  @doc """
  Given a Grid, returns that grid with values flipped (mirrored) horizontally.
  """
  def flip_horiz(grid) do
    grid
    |> rows
    |> Enum.map(&Enum.reverse/1)
    |> from_rows()
  end

  @doc """
  Given a Grid, returns that grid with values flipped (mirrored) vertically.
  """
  def flip_vert(grid) do
    grid
    |> cols
    |> Enum.map(&Enum.reverse/1)
    |> from_cols()
  end

  @doc """
  Given a Grid, rotates it by 90 degrees.
  """
  def rotate(grid) do
    grid
    |> flip_vert()
    |> cols
    |> from_rows()
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
    col(grid, 0)
  end

  @doc """
  Returns the column at the rightmost edge of the grid, as a list of cell values.
  """
  def right_edge(grid) do
    col(grid, grid.x_max)
  end

  @doc """
  Returns the topmost row of the grid as a list of cell values.
  """
  def top_edge(grid) do
    row(grid, 0)
  end

  @doc """
  Returns the lowest row of the grid as a list of cell values.
  """
  def bottom_edge(grid) do
    row(grid, grid.y_max)
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
  Given two grids of equal size, sticks the second grid onto the right edge of the first grid.
  """
  def append_grid([], other) do
    other
  end

  def append_grid(grid, other) do
    rows_g = rows(grid)
    rows_o = rows(other)
    y_max = length(rows_g) - 1

    for y <- 0..y_max  do
      Enum.at(rows_g, y) ++ Enum.at(rows_o, y)
    end
    |> from_rows()
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
