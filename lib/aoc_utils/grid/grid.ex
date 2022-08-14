defmodule AocUtils.Grid2D do
  @moduledoc """
  Defines a data structure for working with a 2-dimensional grid of values.

  The Grid2D is indexed "graphics" style, where the top left corner is 0,0 and indices increase as you move
  right and down.

  It differs somewhat from a "traditional" 2d array in that the implementation is not actually backed by
  arrays, but presents a fairly similar interface. In Elixir it turns out that it is much easier to write
  this kind of data structure as a map where the keys are tuples referring to indices of the grid.

  Grids can be constructed either with Grid2D.new, which allow the most customization of the Grid's
  properties. Or, slightly more conveniently, you can use from_rows, from_strs, or from_cols to create a
  grid from a list containing a representation of a grid's rows.

  Functions are provided for various ways of manipulating and accessing the Grid. The internal representation
  of the Grid is a Map, and in most cases I've tried to emulate the Map API.
  """

  alias AocUtils.Grid2D

  defstruct grid_map: %{}, x_max: 0, y_max: 0, x_min: 0, y_min: 0

  @doc """
  Produces a new Grid2D.

  Accepts the following optional keyword parameters:
  * :x_min - sets the minimum x coordinate of the grid. If not passed, defaults to 0. Must be less than y_max.
  * :y_min - sets the minimum y coordinate of the grid. If not passed, defaults to 0. Must be less than y_max.
  * :x_max - sets the maximum x coordinate of the grid. If not passed, defaults to 0.
  * :y_max - sets the maximum y coordinate of the grid. If not passed, defaults to 0.
  * :default - defines the default value for each cell of the grid. When not given, grid position keys will not exist until
    explicitly set using Grid2D.update or similar.
  """
  def new(params \\ []) do
    x_max = Keyword.get(params, :x_max, 0)
    y_max = Keyword.get(params, :y_max, 0)
    x_min = Keyword.get(params, :x_min, 0)
    y_min = Keyword.get(params, :y_min, 0)

    if(x_max < x_min, do: raise(Grid2D.InvalidGridDimensionsError,"x_min must be less than or equal to x_max."))
    if(y_max < y_min, do: raise(Grid2D.InvalidGridDimensionsError,"y_min must be less than or equal to y_max."))

    grid_map =
      if Keyword.has_key?(params, :default) do
        default = Keyword.get(params, :default)

        for x <- x_min..x_max,
            y <- y_min..y_max do
          {{x, y}, default}
        end
        |> Enum.into(%{})
      else
        %{}
      end

    %Grid2D{
      grid_map: grid_map,
      x_min: x_min,
      x_max: x_max,
      y_min: y_min,
      y_max: y_max,
    }
  end

  @doc """
  Given a size in the x and y directions, and a value, creates a Grid of the given size. This function assumes that the
  grid's top left coordinate is 0,0. For a more flexible construction, see Grid2D.new/1.

  If a default value is passed, the grid will be complete - all indices on the grid will exist as keys in the grid_map.
  If a sparse grid is required, see Grid2D.new/2. If the grid needs to have negative indices, see Grid2D.new/4
  """
  def new(x_max, y_max, default) do
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

  This function assumes that the grid's x_min and y_min are zero. For a more configurable constructor, see Grid2D.new.

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

  This function assumes that the grid's x_min and y_min are zero. For a more configurable constructor, see Grid2D.new.

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

  This function assumes that the grid's x_min and y_min are zero. For a more configurable constructor, see Grid2D.new.

  All lists given in the list must be of the same length.
  """
  def from_columns(cols) do
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

  defdelegate from_cols(cols), to: Grid2D, as: :from_columns

  @doc """
  Converts a Grid to a list of strings, where each string is the concatentation of the
  values in a row of the Grid.

  Accepts an optional argument `spacer` which will be used to fill in any non-occupied spaces in the grid. By default,
  non-occupied spaces will be subsituted with a single space.
  """
  def to_strs(grid, spacer \\ " ") do
    rows(grid, spacer)
    |> Enum.map(&Enum.join/1)
  end

  @doc """
  Converts a Grid to a list of lists, where each of the lists represents the ordered values
  of a row in the Grid.

  Accepts an optional default value to insert into the row list when a given position is unoccupied. If no
  default is passed, nils will be inserted for any unoccupied position.
  """
  def rows(%Grid2D{} = grid, default \\ nil) do
    for y <- grid.y_min..grid.y_max do
      for x <- grid.x_min..grid.x_max do
        Map.get(grid.grid_map, {x, y}, default)
      end
    end
  end

  @doc """
  Returns the row at the given y value as a list of cell values.

  In cases where the Grid is not populated at a given row index, nil will be inserted.
  """
  def row(grid, y, default \\ nil) do
    rows(grid, default)
    |> Enum.at(y)
  end

  @doc """
  Returns the column at the given x value as a list of cell values.
  """
  def column(grid, x, default \\ nil) do
    columns(grid, default)
    |> Enum.at(x)
  end

  defdelegate col(grid, x, default \\ nil), to: Grid2D, as: :column

  @doc """
  Converts a Grid to a list of lists, where each of the lists represents the ordered values
  of a column in the Grid.

  Accepts an optional default value to insert into the row list when a given position is unoccupied. If no
  default is passed, nils will be inserted for any unoccupied position.
  """
  def columns(grid, default \\ nil) do
    for x <- grid.x_min..grid.x_max do
      for y <- grid.y_min..grid.y_max do
        Map.get(grid.grid_map, {x, y}, default)
      end
    end
  end

  defdelegate cols(grid, default \\ nil), to: Grid2D, as: :columns

  @doc """
  Given a Grid2D, converts it to a list of {{x,y}, val} tuples.

  Note that in so doing, the x_min, x_max, y_min, y_max fields are lost. If the grid is sparsely populated, this may
  result in losing information about the dimensions of the grid.
  """
  def to_list(grid) do
    :maps.to_list(grid.grid_map)
  end

  @doc """
  Returns the value of the Grid cell at the given `{x, y}` location. Raises GridAccessError if the given location
  does not exist in the Grid.
  """
  def at!(grid, {x, y} = location) do
    if x > grid.x_max
       or x < grid.x_min
       or y > grid.y_max
       or y < grid.y_min
       do
      raise(Grid2D.GridAccessError, "Grid position #{inspect(location)} is outside the bounds of the grid.")
    end

    if not Map.has_key?(grid.grid_map, location) do
      raise(Grid2D.GridAccessError, "There is no value at grid position {2, 1}")
    end

    Map.get(grid.grid_map, location)
  end

  @doc """
  Returns the value of the Grid cell at the given `{x, y}` location.

  Accepts an optional `default` value, which will be returned if the given cell does not have a value. By default,
  `nil` will be returned for unoccupied cells.
  """
  def at(grid, {x, y}, default \\ nil) do
    Map.get(grid.grid_map, {x, y}, default)
  end

  @doc """
  Updates the value at the given grid position to the given value.

  If the position is outside the bounds of the Grid, the grid will be returned unmodified.
  """
  def update(grid, {x, y}, _value)
    when
      x < grid.x_min
      or x > grid.x_max
      or y < grid.y_min
      or y > grid.y_max
  do
    grid
  end

  def update(grid, {_x, _y} = location, value) do
    %Grid2D{ grid | grid_map: Map.put(grid.grid_map, location, value)}
  end

  @doc """
  Updates the value at the given grid position with the given function.

  If the position is already present in the map, its value is passed to the `update_fn` and its result is used
  as the updated value at that position. If the location is not present, and within the bounds of the map, the default
  value will be inserted.

  If the position is outside the bounds of the Grid, the grid will be returned unmodified.
  """
  def update(grid, location, update_fn, default) when is_function(update_fn) do
    new_value = if Map.has_key?(grid.grid_map, location) do
      update_fn.(at(grid, location))
    else
      default
    end

    new_grid_map = Map.put(grid.grid_map, location, new_value)

    %Grid2D{ grid | grid_map: new_grid_map}
  end

  @doc """
  Updates the value at the location. Accepts either an update_fn, which will be called with the current value at the location,
  or a value to be placed at the given location.

  If the location is not present in the grid, or outside its boundaries, a GridAccessError exception will be raised.
  """
  def update!(
    %Grid2D{} = grid,
    {_x, _y} = location,
    update_fn)
    when is_function(update_fn)
  do
    new_value = update_fn.(at(grid, location))

    update!(grid, location, new_value)
  end

  def update!(
    %Grid2D{} = grid,
    {x, y} = location,
    value) when not is_function(value) do

    if x > grid.x_max
       or x < grid.x_min
       or y > grid.y_max
       or y < grid.y_min
       do
      raise(Grid2D.GridAccessError, "Grid position #{inspect(location)} is outside the bounds of the grid.")
    end

    if not Map.has_key?(grid.grid_map, location) do
      raise(Grid2D.GridAccessError, "Attempted to access non-existent Grid cell at position: #{inspect(location)}")
    end

    new_grid_map = Map.put(grid.grid_map, location, value)

    %Grid2D{ grid | grid_map: new_grid_map}
  end

  @doc """
  Merges two grids into one by overlaying `g2` onto `g1`. `g2`'s top left corner will be placed at the given `location`.
  In cases where points in the merge conflict, they will be resolved through the given `merge_function`.

  Merging of Grids of different sizes is supported. However, g2 must fit completely inside of the boundaries of g1 when overlaid
  at the given offset. In practice, this means that offset may only be used when g2 is smaller in its dimensions than g1. Additionally,
  negative valued offsets are unsupported and will raise an exception. As a rule, if you're merging grids of different sizes,
  you must pass the bigger grid as g1, and the smaller as g2.

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

  def merge(_g1, _g2, {x_offset, y_offset} = merge_loc , _merge_function)
    when x_offset < 0
    or y_offset < 0
  do
    raise(
      Grid2D.InvalidGridMergeError,
      "Proposed merge of g2 onto g1 at position #{inspect(merge_loc)} is invalid. Negative values are not allowed in merge locations."
    )
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
  Returns true if the given function returns a truthy value for every occupied cell in the grid. If a given
  cell is unoccupied, the function will not be called - this only verifies values in occupied cells.

  The function will be passed a {location, value} tuple.
  """
  def all?(grid, test_fn) do
    to_list(grid)
    |> Enum.all?(test_fn)
  end

  @doc """
  Given a grid and a location, returns a list of values from adjacent occupied cells. This includes diagonal neighbors.

  See Grid2D.edge_neighbors and Grid2D.edge_neighbor_locs if you only want neighbors in "straight" directions.
  """
  def neighbors(grid, loc) do
    neighbor_locs(grid, loc)
    |> Enum.map(fn loc ->
      at(grid, loc)
    end)
  end

  @doc """
  Given a grid and a location, returns a list of {x,y} tuples representing existing grid locations bordering that cell.
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
  Given a grid and a location, returns a list of adjacent occupied cell values bordering the location on its edges
  (i.e. _not_ on corners, so this does not include values from cells which are diagonally adjacent).
  """
  def edge_neighbors(grid, loc) do
    edge_neighbor_locs(grid, loc)
    |> Enum.map(fn loc ->
      at(grid, loc)
    end)
  end

  @doc """
  Given a grid and a location, returns the list of existing locations bordering that cell on its edges (i.e. _not_ on corners, so this
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
    y_max = grid.y_max

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

    {from_rows(g_up_rows), from_rows(g_down_rows)}
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
