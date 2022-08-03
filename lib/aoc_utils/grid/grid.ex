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
  Produces a new Grid2D from a list of values.

  Grids can be constructed from a few different types of inputs:
    * A list of lists of values. This is the most flexible method of constructing a Grid2D, allowing the caller
      to index arbitrary types of values. The lists in the list must expected to be of equal length.
    * A list of strings (binaries). This is provided as a convenient method of constructing a Grid2D when the values
      in each cell will be a single character. The given strings are split apart into characters with String.graphemes/1.
    * A list of {key, value} tuples. The keys must be {x,y} coordinate pairs. This is meant primarily
      to be used to convert the results calls to functions in Enum (which rely on the Grid's implementation of the
      Enumerable protocol) back to Grid2Ds.

    Alright, all that is neat in principle, but is a lie. For now this only accepts a list of values, and just
    delegates to from_rows.
  """
  def new(list) when is_list(list) do
    from_rows(list)
  end

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
  really only useful for debugging the 2020 Day 20 code and as a convenience method for testing.
  In general, you probably shouldn't use this outside those two use cases.
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
  Returns the col at the given x value as a list of cell values.
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
  Returns the value of the Grid cell at the given coordinates.
  """
  def at(grid, {x, y}) do
    Map.get(grid.grid_map, {x, y})
  end

  def at(grid, x, y) do
    at(grid, {x, y})
  end

  @doc """
  Updates the value at the given location.

  Raises GridAccessError if given a location that is not in the Grid.
  """
  def update(
    %Grid2D{grid_map: grid_map, x_max: x_max, y_max: y_max},
    {_x, _y} = location,
    value) do

    if not Map.has_key?(grid_map, location) do
      raise(Grid2D.GridAccessError, location)
    end

    new_map = %{grid_map | location => value}

    %Grid2D{
      grid_map: new_map,
      x_max: x_max,
      y_max: y_max,
    }
  end

  @doc """
  Returns a Grid whose cells have been updated by the given function.

  The given function will be invoked with a tuple of {grid_location, cell_value}. The result of the function
  will be stored as the new value of the cell at the location.

  It is important to note that this function behaves slightly differently than calling Enum.map against a
  regular Map. The function's result can only update the _value_ of the cell, and is not able to affect
  the key. This is by design in order to preserve the structure of the Grid.
  """
  def map(%Grid2D{grid_map: grid_map, x_max: x_max, y_max: y_max}, function) do
    new_map =
      grid_map
      |> Map.to_list()
      |> Enum.map(fn {position, value} ->
        new_value = function.({position, value})
        {position, new_value}
      end)
      |> Map.new()

    %Grid2D{
      grid_map: new_map,
      x_max: x_max,
      y_max: y_max,
    }

  end

  @doc """
  Given a grid and a location, returns a list of adjacent cell values bordering the location on its edges
  (i.e. _not_ on corners, so this does not include values from cells which are diagonally adjacent).
  """
  def edge_neighbors(grid, loc) do
    edge_neighbor_locs(grid, loc)
    |> Enum.map(fn loc ->
      at(grid, loc)
    end)
  end

  @doc """
  Given a grid and a location, returns the list of locations bordering that cell on its edges (i.e. _not_ on corners, so this
  does not include locations which are diagonally adjacent).
  """
  def edge_neighbor_locs(grid, {x, y}) do
    neighbor_offsets = [
      {1, 0},
      {-1, 0},
      {0, 1},
      {0, -1},
    ]

    neighbor_offsets
    |> Enum.map(fn {x_offset, y_offset} ->
      {x + x_offset, y + y_offset}
    end)
    |> Enum.filter(fn loc ->
      Map.has_key?(grid.grid_map, loc)
    end)
  end

  @doc """
  Given a Grid2D, converts it to a list of {{x,y}, val} tuples.

  Note that in so doing, the x_max and y_max fields are lost, and must be recomputed to construct a
  new Grid2D.
  """
  def to_list(grid) do
    :maps.to_list(grid.grid_map)
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
  Prints as a Grid all mashed together - not particularly useful outside of Aoc 2020 Day 20 debugging.
  Don't use.
  """
  def print(grid) do
    to_strs(grid)
    |> Enum.map(&IO.puts/1)
  end

  ## Edge access / manipulation
  defdelegate left_edge(grid), to: Grid2D.Edges
  defdelegate right_edge(grid), to: Grid2D.Edges
  defdelegate top_edge(grid), to: Grid2D.Edges
  defdelegate bottom_edge(grid), to: Grid2D.Edges
  defdelegate trim_edges(grid), to: Grid2D.Edges

  ## Transformation functions
  defdelegate all_orientations(grid), to: Grid2D.Transformations
  defdelegate orient_edge_top(grid, edge), to: Grid2D.Transformations
  defdelegate orient_edge_to_direction(grid, edge, direction), to: Grid2D.Transformations
  defdelegate flip_horiz(grid), to: Grid2D.Transformations
  defdelegate flip_vert(grid), to: Grid2D.Transformations
  defdelegate rotate(grid), to: Grid2D.Transformations
  defdelegate rotate180(grid), to: Grid2D.Transformations
  defdelegate rotate270(grid), to: Grid2D.Transformations

  ## Protocol impls
  # SOON

  # from a quick grep through the Elixir source, it looks like Map implements the following protocols:
  # Enumerable
  # Collectable
  # Size
  # Inspect
  # Iex.Info

  defimpl Enumerable, for: Grid2D do
    def count(grid) do
      {:ok, map_size(grid.grid_map)}
    end

    def member?(grid, {key, value}) do
      {:ok, match?(%{^key => ^value}, grid.grid_map)}
      # {:error, __MODULE__}
    end

    def slice(_grid) do
      # size = map_size(grid.grid_map)
      # {:ok, size, &Grid2D.to_list/1}
      {:error, __MODULE__}
    end

    def reduce(grid, acc, fun) do
      Enumerable.List.reduce(Grid2D.to_list(grid), acc, fun)
    end
  end
end
