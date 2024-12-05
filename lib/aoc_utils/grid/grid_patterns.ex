defmodule AocUtils.Grid2D.Patterns do
  alias AocUtils.Grid2D
  alias AocUtils.Grid2D.Patterns.InvalidGridPatternMatchError

  @moduledoc """
  Defines some functions for pattern detection in Grids.
  """

  @doc """
  Given a source_grid and a grid containing some pattern, checks if the pattern is present in the
  source grid at the given origin.

  There are a few important requirements for the pattern grid:
  The pattern grid is assumed to have its origin at (0,0).
  The dimensions of the pattern grid must be less than or equal to those of the source grid.
  All locations present in the pattern grid must be present in the source grid to be considered a match. Sparse
  pattern grids should be used so only important locations are specified.

  The usage of this is a bit hard to describe textually. Take a look at the test file for
  several examples.
  """
  def pattern_match_at_location?(
        source_grid = %Grid2D{},
        pattern_grid = %Grid2D{},
        {x, y} = _location
      ) do
    if Grid2D.x_size(pattern_grid) > Grid2D.x_size(source_grid) do
      raise(
        InvalidGridPatternMatchError,
        "The pattern grid is larger than the source grid in the X dimension"
      )
    end

    if Grid2D.y_size(pattern_grid) > Grid2D.y_size(source_grid) do
      raise(
        InvalidGridPatternMatchError,
        "The pattern grid is larger than the source grid in the y dimension"
      )
    end

    translated_pattern = Grid2D.translate(pattern_grid, {x, y})

    if translated_pattern.x_max > source_grid.x_max ||
         translated_pattern.y_max > source_grid.y_max,
       do:
         raise(
           InvalidGridPatternMatchError,
           "The pattern grid is too large to be placed at the given origin"
         )

    pattern_set = MapSet.new(Grid2D.to_list(translated_pattern))

    extract_top_left = {x, y}
    extract_bottom_right = {translated_pattern.x_max, translated_pattern.y_max}

    source_set =
      source_grid
      |> Grid2D.extract_piece(extract_top_left, extract_bottom_right, preserve_origin: true)
      |> Grid2D.to_list()
      |> MapSet.new()

    MapSet.subset?(pattern_set, source_set)
  end

  @doc """
  Returns a count of how many times the given pattern occurs in the grid.

  Occurences of the pattern are found by moving the pattern to all locations on the Grid which
  can fully contain it (i.e. the pattern is "overlaid" onto the source grid, and will never extend past its edges).

  Internally, this uses `pattern_match_at_location?/3` for pattern checking, so the pattern grid must conform to the requirements laid out in that function.

  Idk if this works if either grid has negative coordinates, and don't currently care enough to fix / test it. Sorry, future me.
  """
  def count_pattern_occurences(source_grid, pattern_grid) do
    {search_x_min, search_y_min} = {source_grid.x_min, source_grid.y_min}

    # the x or y location at which the edge of the pattern is at the edge of the grid
    # TODO: this probably only works on grids without negative coordinates, idk
    search_x_max = source_grid.x_max - (Grid2D.x_size(pattern_grid) - 1)
    search_y_max = source_grid.y_max - (Grid2D.y_size(pattern_grid) - 1)

    search_locs =
      for x <- search_x_min..search_x_max, y <- search_y_min..search_y_max do
        {x, y}
      end

    Enum.map(search_locs, fn loc ->
      pattern_match_at_location?(source_grid, pattern_grid, loc)
    end)
    |> Enum.count(& &1)
  end

  defmodule InvalidGridPatternMatchError do
    @moduledoc """
    Indicates an invalid call to a Grid2D pattern matching function.
    """
    defexception [:message]

    @impl true
    def exception(message) when is_binary(message) do
      %InvalidGridPatternMatchError{message: message}
    end
  end
end
