defmodule Aoc2021.Day13 do
  @moduledoc """
  Ha, looks like another reason to work on Grid2d.

  Alright, so I ended up having to go to reddit and poke around a bit to get a hint, because my code works on the test input and
  it didn't work on the big input. After reading through all my code and being stumped, I started to take a look around. I
  realized my problem was this: you cannot necessarily derive the size of the grid by looking at the max x and max y value
  for the given points. What if there's an empty row on the bottom or an empty column to the side? You wouldn't know that just
  by looking at the input.

  I'm going to be that guy and declare that this is the fault of the puzzle a little bit - apparently all the folds occur at
  midpoints. But there's nothing at all in the puzzle text that makes this guarantee, so if you assume that you might have
  to handle partial folds, you won't necessarily calculate the size of the grid correctly.

  Alright, now back to the code to rewrite the part where we calculate the size of the grid, and I think we'll find that after
  this, everything just works.

  One other quick note - it would probably be faster to do this in a mathy way instead of relying on my grid transformation
  functions to do it in a more "visual" way, but oh well.

  ---

  OK, well shit. After mucking around with the indexing I'm still not getting the right answer.

  I'm confused. I have a few hints, as listed above. One other hint I thought of was this:
  * The only way that I could get _more_ dots than I should have is if the two grids aren't lining up as expected. This doesn't rule
  out the idea of an extra line which could be mucking up the dimensions of the thing. But there are 907 dots in the input, and
  the current version I'm running produces 903 after running the first instruction. So if 903 > answer (which we know from the
  submission of our first answer), then it must be the case that at least some dots are not "cancelling each other out".

  I _know_ I could do this with math, but if everything in Grid works the way it's supposed to, this approach should be possible
  too. What the hell is going wrong?! Another thing is that even if all the folds

  things that have to work the way I think they do for this approach to work:
  * grid must contain an accurate list of all points
    - the grid produced by process_input has 907 cells containing a dot, so this at least passes a sniff test.
    - the points produced by the map function in process_input (which are used a)
  * grid coordinates must have an origin at 0,0 which increases correctly in both directions
  * grid slices must return the full set of points on either side of the cut line.
    - according to the input, dots will never appear along a fold line
    - we have _more_ dots than we need, not less
      - we only lose 4 dots to the first fold, which seems a bit off.
  * grid coordinates must be correctly recalculated when a grid is flipped
  * grid merge offset must be correctly calculated
  * grid merge must work as expected


  how is it possible that my solution is correct for the sample input but not the real one?

  * assuming negative indices are not allowed in the final image, based on ... well, nothing, but that feels pretty weird

  Quick order of operations thus far:
  Make a new grid filled with "." of a size we're not sure is accurate
  Cut it along the line, leaving two halves equal in either x or y
  flip the bottom or right half in the appropriate direction
  merge the top or left half with the flipped other half

  count the points with dots in the resulting grid

  what situation could these assumptions or steps work differently for one grid than another?
  * if lower half == flipped(lower half), you could get the right answer for that grid without flipping the half
  * if the offset was incorrect for the merge, but you coincidentally calculate an offset which still gives the right answer becase
    a specific arrangement of dots would merge into the same final result with the incorrect offset.
    - for example, as a semi-trivial case, if the top half was filled with dots, and your cut line only gives you one row, also
      full of dots, then there would be some range of indices where you could merge that row and you'd still have the same number of
      dots... this seems pretty unlikely for our inputs but we could write a test around this idea?


  =============

  omfg

  i had the fold directions reversed. you need to fold _left_ for a fold along a x line and _up_ for y line.

  unbelievable lol.
  """

  alias AocUtils.Grid2D

  @doc """
  Takes the puzzle input and returns the dot grid and the list of fold instructions.
  """
  def process_input(input) do
    [dot_strs, fold_strs] = String.split(input, "\n\n")

    folds =
      fold_strs
      |> String.split("\n")
      |> Enum.map(fn fold_str ->
        [_, fold_dir, fold_line] = Regex.run(~r/([xy])=(\d+)/, fold_str)

        cond do
          fold_dir == "x" -> {:left, String.to_integer(fold_line)}
          fold_dir == "y" -> {:up, String.to_integer(fold_line)}
        end
      end)

    # the first fold in either direction occurs along the midpoint of the grid in that axis
    {_first_up_fold, y_midpoint } = Enum.find(folds, fn {direction, _} -> direction == :up end)
    {_first_left_fold, x_midpoint } = Enum.find(folds, fn {direction, _} -> direction == :left end)

    x_max = (x_midpoint * 2)
    y_max = (y_midpoint * 2)

    dot_locs =
      dot_strs
      |> String.split("\n")
      |> Enum.map(fn dot_str ->
        [dot_x, dot_y] = String.split(dot_str, ",") |> Enum.map(&String.to_integer/1)
        {dot_x, dot_y}
      end)

    grid_no_dots =
      Grid2D.new(x_max: x_max, y_max: y_max)

    grid = Enum.reduce(dot_locs, grid_no_dots, fn dot_loc, grid ->
      Grid2D.update(grid, dot_loc, "#")
    end)

    %{ grid: grid, folds: folds }
  end

  @doc """
  Folds the grid left along the given line at {fold_line_x, 0}.
  """
  def fold_left(grid, fold_line_x) do
    {g_left, g_right} = Grid2D.slice_vertically(grid, fold_line_x)

    g_right = Grid2D.flip_horiz(g_right)
    Grid2D.merge(g_left, g_right, {0,0}, fn _k, v_l, v_r -> (if (v_l == "#" or v_r == "#"), do: "#", else: nil) end)
  end

  @doc """
  Folds the grid up along the given line at {0, fold_line_y}.
  """
  def fold_up(grid, fold_line_y) do
    {g_up, g_down} = Grid2D.slice_horizontally(grid, fold_line_y)

    g_down = Grid2D.flip_vert(g_down)
    Grid2D.merge(g_up, g_down, {0,0}, fn _k, v_l, v_r -> (if (v_l == "#" or v_r == "#"), do: "#", else: ".") end)
  end

  def do_fold(grid, {direction, line}) do
    cond do
      direction == :left -> fold_left(grid, line)
      direction == :up -> fold_up(grid, line)
    end
  end

  def part_1(input) do
    %{grid: grid, folds: folds} = process_input(input)

    first_fold = hd(folds)
    folded_grid = do_fold(grid, first_fold)

    Enum.count(folded_grid, fn {_, v} -> v == "#" end)
  end

  def part_2(input) do
    %{grid: grid, folds: folds} = process_input(input)

    grid = Enum.reduce(folds, grid, fn fold, grid ->
      do_fold(grid, fold)
    end)

    Grid2D.to_strs(grid)
  end
end
