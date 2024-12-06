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

    if(x_max < x_min,
      do: raise(Grid2D.InvalidGridDimensionsError, "x_min must be less than or equal to x_max.")
    )

    if(y_max < y_min,
      do: raise(Grid2D.InvalidGridDimensionsError, "y_min must be less than or equal to y_max.")
    )

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
      y_max: y_max
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

  Accepts optional config argument :ignore. If you pass a single character binary with this option, that string will be
  ignored in the input.

  All strings given in the list must be of the same length.
  """
  def from_strs(strs, options \\ []) do
    ignore_char = Keyword.get(options, :ignore)

    grid_chars = strs |> Enum.map(&String.graphemes/1)

    y_max = length(grid_chars) - 1
    x_max = length(Enum.at(grid_chars, 0)) - 1

    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        state = grid_chars |> Enum.at(y) |> Enum.at(x)
        if(state == ignore_char, do: nil, else: {{x, y}, state})
      end
      |> Enum.reject(&is_nil/1)
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

  Accepts an optional 'ignore_value`. Any occurrences of the `ignore_value` in the input will be ignored, and not
  added to the grid. By default, `ignore_value` is nil, and nils will not be added to the grid.

  This function assumes that the grid's x_min and y_min are zero. For a more configurable constructor, see Grid2D.new.

  All lists given in the input should be of the same length.
  """
  def from_rows(rows, ignore_value \\ nil) do
    y_max = length(rows) - 1
    x_max = length(Enum.at(rows, 0)) - 1

    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        state = rows |> Enum.at(y) |> Enum.at(x)
        if(state == ignore_value, do: nil, else: {{x, y}, state})
      end
      |> Enum.reject(&is_nil/1)
      |> Map.new()

    %Grid2D{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

  @doc """
  Produces a grid from a list of lists. Each list in the list represents a column in the grid, and
  each value in a given list represents a cell in that column.

  Accepts an optional 'ignore_value`. Any occurrences of the `ignore_value` in the input will be ignored, and not
  added to the grid. By default, `ignore_value` is nil, and nils will not be added to the grid.

  This function assumes that the grid's x_min and y_min are zero. For a more configurable constructor, see Grid2D.new.

  All lists given in the list must be of the same length.
  """
  def from_columns(cols, ignore_value \\ nil) do
    x_max = length(cols) - 1
    y_max = length(Enum.at(cols, 0)) - 1

    grid_map =
      for x <- 0..x_max,
          y <- 0..y_max do
        state = cols |> Enum.at(x) |> Enum.at(y)
        if(state == ignore_value, do: nil, else: {{x, y}, state})
      end
      |> Enum.reject(&is_nil/1)
      |> Enum.into(%{})

    %Grid2D{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

  defdelegate from_cols(cols, ignore_value \\ nil), to: Grid2D, as: :from_columns

  @doc """
  Creates a Grid from a list of key-value tuples, where keys are tuples of {x,y} coordinates, and the value is the value at that location.

  Note that the new Grid's x_min, x_max, y_min, and y_max will be determined by the min/max points in the
  given list.

  Raises an ArgumentError if the given list is malformed.
  """
  def from_list(list) do
    list_valid? =
      Enum.all?(list, fn
        {{_x, _y}, _v} -> true
        _ -> false
      end)

    if not list_valid?,
      do: raise(ArgumentError, "Failed to create Grid from list. Input list is malformed.")

    {{{new_x_min, _}, _}, {{new_x_max, _}, _}} = Enum.min_max_by(list, fn {{x, _y}, _v} -> x end)
    {{{_, new_y_min}, _}, {{_, new_y_max}, _}} = Enum.min_max_by(list, fn {{_x, y}, _v} -> y end)

    %Grid2D{
      grid_map: Enum.into(list, %{}),
      x_min: new_x_min,
      x_max: new_x_max,
      y_min: new_y_min,
      y_max: new_y_max
    }
  end

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
    if x > grid.x_max or
         x < grid.x_min or
         y > grid.y_max or
         y < grid.y_min do
      raise(
        Grid2D.GridAccessError,
        "Grid position #{inspect(location)} is outside the bounds of the grid."
      )
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
  def at(grid, {x, y} = _location, default \\ nil) do
    Map.get(grid.grid_map, {x, y}, default)
  end

  @doc """
  Updates the value at the given grid position to the given value.

  If the position is outside the bounds of the Grid, the grid will be returned unmodified.
  """
  def update(grid, {x, y} = _location, _value)
      when x < grid.x_min or
             x > grid.x_max or
             y < grid.y_min or
             y > grid.y_max do
    grid
  end

  def update(grid, {_x, _y} = location, value) do
    %Grid2D{grid | grid_map: Map.put(grid.grid_map, location, value)}
  end

  @doc """
  Updates the value at the given grid position with the given function.

  If the position is already present in the map, its value is passed to the `update_fn` and its result is used
  as the updated value at that position. If the location is not present, and within the bounds of the map, the default
  value will be inserted.

  If the position is outside the bounds of the Grid, the grid will be returned unmodified.
  """
  def update(grid, location, update_fn, default) when is_function(update_fn) do
    new_value =
      if Map.has_key?(grid.grid_map, location) do
        update_fn.(at(grid, location))
      else
        default
      end

    new_grid_map = Map.put(grid.grid_map, location, new_value)

    %Grid2D{grid | grid_map: new_grid_map}
  end

  @doc """
  Updates the value at the location. Accepts either an update_fn, which will be called with the current value at the location,
  or a value to be placed at the given location.

  If the location is not present in the grid, or outside its boundaries, a GridAccessError exception will be raised.
  """
  def update!(
        %Grid2D{} = grid,
        {_x, _y} = location,
        update_fn
      )
      when is_function(update_fn) do
    new_value = update_fn.(at(grid, location))

    update!(grid, location, new_value)
  end

  def update!(
        %Grid2D{} = grid,
        {x, y} = location,
        value
      )
      when not is_function(value) do
    if x > grid.x_max or
         x < grid.x_min or
         y > grid.y_max or
         y < grid.y_min do
      raise(
        Grid2D.GridAccessError,
        "Grid position #{inspect(location)} is outside the bounds of the grid."
      )
    end

    if not Map.has_key?(grid.grid_map, location) do
      raise(
        Grid2D.GridAccessError,
        "Attempted to access non-existent Grid cell at position: #{inspect(location)}"
      )
    end

    new_grid_map = Map.put(grid.grid_map, location, value)

    %Grid2D{grid | grid_map: new_grid_map}
  end

  @doc """
  Merges two grids into one by overlaying `g2` onto `g1`. If an `offset` is passed, `g2`'s locations will be translated such that
  the given offset is the top-left coordinate in g2.

  In cases where points in the merge conflict, they will be resolved through the given `merge_function`.

  The `merge_function` is given the position and the values from g1 and g2. (i.e. the signature of the function should be `fn k, v1, v2 ->`
  The merge function will only run for grid positions which are populated, and takes place _after_ the translation of g2 to the offset.

  Merges may extend the boundaries of the resulting grid in any direction. It is important to note that the `offset` will always be
  applied to `g2`. As a general rule, it will usually make the most sense to pass the larger of the two grids as g1.
  """
  def merge(g1, g2, {0, 0} = _location, merge_function)
      when is_function(merge_function) and
             g1.x_min == g2.x_min and
             g1.x_max == g2.x_max and
             g1.y_min == g2.y_min and
             g2.y_max == g2.y_max do
    # easy case, where grids are of the same size and no offset
    %Grid2D{
      x_min: g1.x_min,
      x_max: g1.x_max,
      y_min: g1.y_min,
      y_max: g1.y_max,
      grid_map: Map.merge(g1.grid_map, g2.grid_map, merge_function)
    }
  end

  def merge(g1, g2, {x_offset, y_offset} = _merge_loc, merge_function)
      when is_function(merge_function) do
    g2_new_x_min = g2.x_min + x_offset
    g2_new_x_max = g2.x_max + x_offset
    g2_new_y_min = g2.y_min + y_offset
    g2_new_y_max = g2.y_max + y_offset

    new_x_min = min(g1.x_min, g2_new_x_min)
    new_x_max = max(g1.x_max, g2_new_x_max)
    new_y_min = min(g1.y_min, g2_new_y_min)
    new_y_max = max(g1.y_max, g2_new_y_max)

    g2_grid_map_with_new_positions =
      g2
      |> to_list()
      |> Enum.map(fn {{old_x, old_y}, v} ->
        {{old_x + x_offset, old_y + y_offset}, v}
      end)
      |> Map.new()

    new_grid_map = Map.merge(g1.grid_map, g2_grid_map_with_new_positions, merge_function)

    %Grid2D{
      x_min: new_x_min,
      x_max: new_x_max,
      y_min: new_y_min,
      y_max: new_y_max,
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
      y_max: y_max
    }
  end

  @doc """
  Returns a list of locations in the Grid for which the given function returns a truthy
  value.

  The given function will be invoked with a tuple of {grid_location, cell_value}, and should return
  either a truthy or falsy value.
  """
  def matching_locs(%Grid2D{} = grid, function) do
    grid
    |> to_list()
    |> Enum.map(fn {position, value} ->
      {position, function.({position, value})}
    end)
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.map(fn {pos, _} -> pos end)
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
      # up
      {0, -1},
      # up-right
      {1, -1},
      # right
      {1, 0},
      # down-right
      {1, 1},
      # down
      {0, 1},
      # down-left
      {-1, 1},
      # left
      {-1, 0},
      # up-left
      {-1, -1}
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
      {0, -1}
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
  Given two grids, sticks the second grid onto the right edge of the first grid. In general you probably want to use
  `merge` - that was written for AoC2020 and is currently only used in the Day 20 puzzle.
  """
  def append_grid([], other) do
    other
  end

  def append_grid(grid, other) do
    merge(grid, other, {grid.x_max + 1, 0}, fn _, _, g2 -> g2 end)
  end

  @doc """
  Prints as a Grid all mashed together - not particularly useful outside of Aoc 2020 Day 20 debugging.

  Returns the grid, unmodified - like IO.inspect
  """
  def print(grid) do
    to_strs(grid)
    |> Enum.map(&IO.puts/1)

    grid
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
    g_left_cols = Enum.slice(cols, 0..(x - 1))
    g_right_cols = Enum.slice(cols, (x + 1)..length(cols))

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
    g_up_rows = Enum.slice(rows, 0..(y - 1))
    g_down_rows = Enum.slice(rows, (y + 1)..length(rows))

    {from_rows(g_up_rows), from_rows(g_down_rows)}
  end

  # @doc """
  # Translates a grid's coordinates to the given origin `{h, k}`, resulting in a grid whose top left corner is at `{h,k}`.
  # """
  def translate(grid, {h, k} = _origin) do
    x_shift = h - grid.x_min
    y_shift = k - grid.y_min

    new_grid_map =
      grid
      |> to_list()
      |> Enum.map(fn {{x, y}, v} ->
        {{x + x_shift, y + y_shift}, v}
      end)
      |> Map.new()

    %Grid2D{
      x_min: h,
      x_max: h + abs(grid.x_max - grid.x_min),
      y_min: k,
      y_max: k + abs(grid.y_max - grid.y_min),
      grid_map: new_grid_map
    }
  end

  @doc """
  Given a source grid, and two points specifying a rectangle within its bounds, extracts a rectangular
  section of the grid and returns it as a section. The specified points are the corners of the rectangle
  and the extraction is inclusive of the corner points.

  The function will raise a GridAccessException if the specified rectangle extends
  beyond the bounds of the source grid.

  extract_piece receives the following parameters:
  * `source_grid` - the grid from which to extract a piece
  * `_top_left` - a tuple representing the top-left corner of the rectangle to extract
  * `_bottom_right` - a tuple representing the bottom-right corner of the rectangle to extract
  * `options` - a keyword list representing optional features. See "Options" section below.

  ### Options
  * :preserve_origin - by default, the extracted rectangle will be translated so that its origin
  is at (0,0). Passing `preserve_origin: true` will cause the extracted rectangle to maintain its original
  coordinates (i.e. `{x_min, y_min}` will be set to the given location for `top_left`, and `{x_max, y_max} will correspond to `bottom_right`)

  """
  def extract_piece(source_grid, {x1, y1} = _top_left, {x2, y2} = _bottom_right, options \\ []) do
    %Grid2D{
      grid_map: source_grid_map,
      x_max: source_grid_x_max,
      x_min: source_grid_x_min,
      y_min: source_grid_y_min,
      y_max: source_grid_y_max
    } = source_grid

    if x1 < source_grid_x_min or y1 < source_grid_y_min or x2 > source_grid_x_max or
         y2 > source_grid_y_max do
      raise(
        Grid2D.GridAccessError,
        "Rectangle passed to extract_piece extends beyond the bounds of source_grid"
      )
    end

    new_grid =
      for x <- x1..x2,
          y <- y1..y2 do
        {{x, y}, Map.get(source_grid_map, {x, y}, nil)}
      end
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> from_list()

    preserve_origin? = Keyword.get(options, :preserve_origin, false)

    if preserve_origin? do
      new_grid
    else
      translate(new_grid, {0, 0})
    end
  end

  @doc """
  Returns a grid's vertical size (abs(y_max - y_min)).
  """
  def y_size(%{y_max: y_max, y_min: y_min} = %Grid2D{}) do
    abs(y_max - y_min) + 1
  end

  @doc """
  Returns a grid's horizontal size (abs(x_max - x_min)).
  """
  def x_size(%{x_max: x_max, x_min: x_min} = %Grid2D{}) do
    abs(x_max - x_min) + 1
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
