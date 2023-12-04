defmodule Aoc2023.Day03 do
  alias AocUtils.Grid2D, as: Grid

  @doc """
  Given a location on the grid, which is known to contain a number character, searches the
  grid left and right to construct the full number.

  Returns a map like this:
  %{
    n: number,
    locs: list of locations occupied by the number
  }

  Returns nil if called against a cell that does not contain a number.
  """
  def get_part_number_at_location(grid, {x, y}) do
    left =
      Enum.reduce_while((x - 1)..grid.x_min, %{n_str: "", locs: []}, fn i, acc ->
        grid_val = Grid.at(grid, {i, y})

        if grid_val != nil and grid_val =~ ~r/\d/ do
          {:cont,
           %{
             n_str: grid_val <> acc.n_str,
             locs: acc.locs ++ [{i, y}]
           }}
        else
          {:halt, acc}
        end
      end)

    right =
      Enum.reduce_while(x..grid.x_max, %{n_str: "", locs: []}, fn i, acc ->
        grid_val = Grid.at(grid, {i, y})

        if grid_val != nil and grid_val =~ ~r/\d/ do
          {:cont,
           %{
             n_str: acc.n_str <> grid_val,
             locs: acc.locs ++ [{i, y}]
           }}
        else
          {:halt, acc}
        end
      end)

    if left.n_str == "" and right.n_str == "" do
      nil
    else
      %{n: String.to_integer(left.n_str <> right.n_str), locs: left.locs ++ right.locs}
    end
  end

  @doc """
  Given a location on the grid, finds any "part numbers" - i.e. any number
  with at least one character that neighbors the part number in any adjacent cell.
  """
  def get_surrounding_part_numbers(grid, loc) do
    neighbor_locs = Grid.neighbor_locs(grid, loc)

    stuff =
      Enum.reduce(
        neighbor_locs,
        %{part_numbers: [], search_locs: MapSet.new(neighbor_locs)},
        fn loc, acc ->
          if MapSet.member?(acc.search_locs, loc) do
            loc_data = get_part_number_at_location(grid, loc)

            if loc_data != nil do
              new_search_locs =
                MapSet.difference(
                  acc.search_locs,
                  MapSet.new(loc_data.locs)
                )

              %{
                part_numbers: acc.part_numbers ++ [loc_data.n],
                search_locs: new_search_locs
              }
            else
              acc
            end
          else
            acc
          end
        end
      )

    stuff.part_numbers
  end

  @doc """
  Returns the locations of all the symbols in the grid.
  """
  def get_symbol_locations(grid) do
    Grid.matching_locs(grid, fn {_, char_at_loc} ->
      not (char_at_loc =~ ~r/(\d|\.)/)
    end)
  end

  @doc """
  Returns the ratios of all gears in the given grid.

  A gear is any * symbol that is adjacent to exactly two part numbers. The gear ratio is the product
  of those two part numbers.
  """
  def get_gear_ratios(grid) do
    grid
    |> Grid.matching_locs(fn {_, char_at_loc} ->
      char_at_loc == "*"
    end)
    |> Enum.map(fn gear_loc ->
      part_numbers = get_surrounding_part_numbers(grid, gear_loc)

      if length(part_numbers) == 2 do
        [a, b] = part_numbers
        a * b
      else
        nil
      end
    end)
    |> Enum.filter(& &1)
  end

  def part_1(input) do
    grid = input |> Grid.from_strs(ignore: ".")

    grid
    |> get_symbol_locations()
    |> Enum.reduce([], fn symbol_loc, acc ->
      acc ++ get_surrounding_part_numbers(grid, symbol_loc)
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Grid.from_strs(ignore: ".")
    |> get_gear_ratios()
    |> Enum.sum()
  end
end
