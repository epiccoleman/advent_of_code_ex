defmodule Day20.Grid do
  alias Day20.Grid

  defstruct grid_map: %{}, x_max: 0, y_max: 0

  @doc """
  produces a grid from a list of strs
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

    %Grid{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

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

    %Grid{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

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

    %Grid{
      grid_map: grid_map,
      x_max: x_max,
      y_max: y_max
    }
  end

  def to_strs(grid) do
    rows(grid)
    |> Enum.map(&Enum.join/1)
  end

  # def from_vertical_strs(strs) do

  # end

  # def to_vertical_strs(strs) do

  # end

  def rows(%Grid{grid_map: grid_map, x_max: x_max, y_max: y_max}) do
    for y <- 0..y_max do
      for x <- 0..x_max do
        Map.get(grid_map, {x, y})
      end
    end
  end

  def row(grid, n) do
    rows(grid)
    |> Enum.at(n)
  end

  def col(grid, n) do
    cols(grid)
    |> Enum.at(n)
  end

  def cols(%Grid{grid_map: grid_map, x_max: x_max, y_max: y_max}) do
    for x <- 0..x_max do
      for y <- 0..y_max do
        Map.get(grid_map, {x, y})
      end
    end
  end

  def print(grid) do
    to_strs(grid)
    |> Enum.map(&IO.puts/1)
  end

  def at(grid, {x, y}) do
    Map.get(grid.grid_map, {x, y})
  end

  ## transforms

  def flip_horiz(grid) do
    grid
    |> rows
    |> Enum.map(&Enum.reverse/1)
    |> from_rows()
  end

  def flip_vert(grid) do
    grid
    |> cols
    |> Enum.map(&Enum.reverse/1)
    |> from_cols()
  end

  # def rotate(%Grid{grid_map: grid_map, x_max: x_max, y_max: y_max}) do
  #   rotated_map =
  #     for x <- 0..x_max, y <- 0..y_max do
  #       {{x, y}, Map.get(grid_map, {x, x_max - y - 1})}
  #     end
  #     |> Enum.into(%{})

  #   %Grid{
  #     grid_map: rotated_map,
  #     x_max: x_max,
  #     y_max: y_max
  #   }
  # end

  def rotate(grid) do
    grid
    |> flip_vert()
    |> cols
    |> from_rows()
  end

  def rotate180(grid) do
    grid
    |> rotate()
    |> rotate()
  end

  def rotate270(grid) do
    grid
    |> rotate()
    |> rotate()
    |> rotate()
  end

  def get_edge(grid, direction) do

  end

  def left_edge(grid) do
    col(grid, 0)
  end

  def right_edge(grid) do
    col(grid, grid.x_max)
  end

  def top_edge(grid) do
    row(grid, 0)
  end

  def bottom_edge(grid) do
    row(grid, grid.y_max)
  end

  def trim_edges(grid) do
    new_rows =
      Grid.rows(grid)
      |> List.delete_at(grid.y_max)
      |> List.delete_at(0)
      |> Enum.map(fn row -> row |> List.delete_at(grid.x_max) |> List.delete_at(0) end)

    Grid.from_rows(new_rows)
  end

  def orient_edge_top(grid, edge) do
    grid
    |> all_orientations()
    |> Enum.find(fn grid -> top_edge(grid) == edge end)
  end

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

  def all_orientations(grid) do
    # only 8 of these are unique but I cbf to figure out which right now
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
