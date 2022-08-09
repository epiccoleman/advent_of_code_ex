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
  Given a size in the x and y directions, and an optional default value, creates a Grid of the given size.
  """
  def new(x_max, y_max, default \\ nil) do
    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        {{x, y}, default}
      end
      |> Enum.into(%{})

    %Grid2D{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
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
  Given a Grid2D, converts it to a list of {{x,y}, val} tuples.

  Note that in so doing, the x_max and y_max fields are lost, and must be recomputed to construct a
  new Grid2D.
  """
  def to_list(grid) do
    :maps.to_list(grid.grid_map)
  end

  @doc """
  Returns the value of the Grid cell at the given `{x, y}` location. Raises GridAccessError if the given location
  does not exist in the Grid.
  """
  def at(grid, location) do
    if not Map.has_key?(grid.grid_map, location) do
      raise(Grid2D.GridAccessError, location)
    end

    Map.get(grid.grid_map, location)
  end

  def at(grid, x, y) do
    at(grid, {x, y})
  end

  @doc """
  Updates the value at the given location. Can be given either a single value, which will be placed into the
  given location, or a function to be applied to the value at the location. The function receives the location
  and current value of the cell as a tuple.

  Raises GridAccessError if given a location that is not in the Grid.
  """
  def update(grid, location, update_function) when is_function(update_function) do
    if not Map.has_key?(grid.grid_map, location) do
      raise(Grid2D.GridAccessError, location)
    end

    new_value = update_function.(at(grid, location))
    update(grid, location, new_value)
  end

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
  Merges two grids into one by overlaying `g2` onto `g1`. `g2`'s top left corner will be placed at the given `location`.
  In cases where points in the merge conflict, they will be resolved through the given `merge_function`. As a general rule,
  if you're merging grids of different sizes, you should pass the bigger grid as g1, and the smaller as g2.

  Since Grid2Ds must be rectangular, the proposed merge must conform to a few different contraints. `g2`, when overlaid
  at `location` must either:
  * fit within the bounds of `g1`
  * have the same y dimension as `g1` (i.e. the overlay can extend the grid horizontally, but only if it's still rectangular)
  * have the same x dimension as `g1` (i.e. the overlay can extend the grid vertically, but only if it's still rectangular)

  Merges which extend the size of the resulting grid may only extend the grid in the positive x or y direction. Additionally,
  proposed extending merges may only extend the grid in one axis at a time (this restriction can be worked around by remembering
  to pass the larger of the two grids as g1). Finally, extending merges must not leave empty space in the resulting grid.

  Invalid merges will raise Grid2D.InvalidMergeError.
  """
  def merge(g1, g2, {0, 0} = _location, merge_function)
    when is_function(merge_function)
    and g1.x_max == g2.y_max
    and g2.y_max == g2.y_max do

    # easy case, where grids are of the same size and no offset
    %Grid2D{
      x_max: g1.x_max,
      y_max: g1.y_max,
      grid_map: Map.merge(g1.grid_map, g2.grid_map, merge_function)
    }
  end

  def merge(_g1, _g2, {x_offset, y_offset}, _merge_function) when x_offset < 0 or y_offset < 0 do
    raise(Grid2D.InvalidGridMergeError, "Merge positions may not contain negative values.")
  end

  def merge(g1, g2, {x_offset, 0} = loc, merge_function)
    when is_function(merge_function)
    and g1.y_max == g2.y_max
    and x_offset > g1.x_max
  do
    raise(
      Grid2D.InvalidGridMergeError,
      "The proposed merge of the given grids at #{inspect(loc)} would create empty space in the resulting grid.")
  end

  def merge(g1, g2, {x_offset, 0}, merge_function)
    when is_function(merge_function)
    and g1.y_max == g2.y_max
    and x_offset <= g1.x_max
  do
    # this is the case that allows horizontal extension
    :unimplemented
  end

  def merge(g1, g2, {0, y_offset} = loc, merge_function)
    when is_function(merge_function)
    and g1.x_max == g2.x_max
    and y_offset > g1.y_max
  do
    raise(
      Grid2D.InvalidGridMergeError,
      "The proposed merge of the given grids at #{inspect(loc)} would create empty space in the resulting grid.")
  end

  def merge(g1, g2, {0, y_offset}, merge_function)
    when is_function(merge_function)
    and g1.x_max == g2.x_max
    and y_offset <= g1.y_max
  do
    # this is the case that allows vertical extension
    new_y_max = (g1.y_max - y_offset) + g2.y_max
    new_x_max = g1.x_max

    # create a new blank grid with the new dimensions
    # base_grid = new(new_x_max, new_y_max, )
  end

  def merge(g1, g2, {x_offset, y_offset} = merge_loc , merge_function)
    when is_function(merge_function)
  do

    g2_new_x_max = g2.x_max + x_offset
    g2_new_y_max = g2.y_max + y_offset

    if g2_new_x_max > g1.x_max or g2_new_y_max > g1.y_max do
      raise(Grid2D.InvalidGridMergeError, merge_loc)
    end

    g2_grid_map_with_new_positions =
      g2
      |> to_list()
      |> Enum.map(fn {{old_x, old_y}, v} ->
        {{old_x + x_offset, old_y + y_offset}, v}
      end)
      |> Map.new()

    new_grid_map = Map.merge(g1.grid_map, g2_grid_map_with_new_positions, merge_function)

    %Grid2D{
      x_max: g1.x_max,
      y_max: g1.y_max,
      grid_map: new_grid_map
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
  Returns true if the given function returns a truthy value for every cell in the grid.

  The function will be passed a {location, value} tuple.
  """
  def all?(grid, test_fn) do
    to_list(grid)
    |> Enum.all?(test_fn)
  end

  @doc """
  Given a grid and a location, returns a list of values from adjacent cells. This includes diagonal neighbors.

  See Grid2D.edge_neighbors and Grid2D.edge_neighbor_locs if you only want neighbors in "straight" directions.
  """
  def neighbors(grid, loc) do
    neighbor_locs(grid, loc)
    |> Enum.map(fn loc ->
      at(grid, loc)
    end)
  end

  @doc """
  Given a grid and a location, returns a list of {x,y} tuples representing grid locations bordering that cell.
  This includes cells which are diagonally adjacent.

  See Grid2D.edge_neighbors and Grid2D.edge_neighbor_locs if you only want neighbors in "straight" directions.
  """
  def neighbor_locs(grid, {x, y}) do
    neighbor_offsets = [
      {0, -1}, #up
      {1, -1}, #up-right
      {1, 0}, #right
      {1, 1}, #down-right
      {0, 1}, #down
      {-1, 1}, #down-left
      {-1, 0}, #left
      {-1, -1}, #up-left
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
  """
  def print(grid) do
    to_strs(grid)
    |> Enum.map(&IO.puts/1)
  end

  @doc """
  Slices the grid into two separate grids along the vertical line at the given x value.

  Returns a tuple containing the two grids on _either side_ of the line. The first item in the tuple will be the
  grid to the left the slice, and the second item will be the grid to the right of the slice.

  It is important to note that, as currently implemented, all points covered by the cut line will be lost. This is intentional
  as this is what is required by the puzzle for which this function was developed.  (AOC 2021 Day 13).
  """
  def slice_vertically(grid, x) do
    cols = cols(grid)
    g_left_cols = Enum.slice(cols, 0..(x-1))
    g_right_cols = Enum.slice(cols, (x+1)..length(cols))

    {from_cols(g_left_cols), from_cols(g_right_cols)}
  end

  @doc """
  Slices the grid into two separate grids along the horizontal line at the given y value.

  Returns a tuple containing the two grids on _either side_ of the line. The first item in the tuple will be the
  grid _above_ the slice, and the second item will be what is below the slice.

  It is important to note that, as currently implemented, all points covered by the cut line will be lost. This is intentional
  as this is what is required by the puzzle for which this function was developed.  (AOC 2021 Day 13).
  """
  def slice_horizontally(grid, y) do
    rows = rows(grid)
    g_up_rows = Enum.slice(rows, 0..(y-1))
    g_down_rows = Enum.slice(rows, (y+1)..length(rows))

    {new(g_up_rows), new(g_down_rows)}
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
  # from a quick grep through the Elixir source, it looks like Map implements the following protocols:
  # Enumerable
  # Collectable
  # Size?
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
