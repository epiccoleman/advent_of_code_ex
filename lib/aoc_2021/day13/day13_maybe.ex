  defmodule Aoc2021.Day13 do
    @moduledoc """
    FINE I'LL DO MATH
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
            fold_dir == "x" -> {:up, String.to_integer(fold_line)}
            fold_dir == "y" -> {:left, String.to_integer(fold_line)}
          end
        end)

      # the first fold in either direction occurs along the midpoint of the grid in that axis
      {_first_up_fold, y_midpoint } = Enum.find(folds, fn {direction, _} -> :up end)
      {_first_left_fold, x_midpoint } = Enum.find(folds, fn {direction, _} -> :left end)

      # not 100% on this math, let's see what happens
      x_max = (x_midpoint * 2) + 1
      y_max = (y_midpoint * 2) + 1

      dot_locs =
        dot_strs
        |> String.split("\n")
        |> Enum.map(fn dot_str ->
          [dot_x, dot_y] = String.split(dot_str, ",") |> Enum.map(&String.to_integer/1)
          {dot_x, dot_y}
        end)

      # I'm not confident in this but let's just leave it for now, it's time to drop a wip commit.
      {x_max, _} = Enum.max_by(dot_locs, fn {x, _y} -> x end)
      {_, y_max} = Enum.max_by(dot_locs, fn {_x, y} -> y end)

      grid_no_dots =
        Grid2D.new(x_max, y_max, ".")

      grid = Enum.reduce(dot_locs, grid_no_dots, fn dot_loc, grid ->
        Grid2D.update(grid, dot_loc, "#")
      end)

      %{ grid: grid, folds: folds }
    end

    @doc """
    Folds the grid left along the given line at {fold_line_x, 0}.
    """
    def fold_left(grid, fold_line_x) do
      :unimplemented
    end

    @doc """
    Folds the grid up along the given line at {0, fold_line_y}.
    """
    def fold_up(grid, fold_line_y) do
      :unimplemented
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
      input
    end
  end
