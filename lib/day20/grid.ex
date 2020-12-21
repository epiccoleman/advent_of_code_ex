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


      grid_map = for x <- 0..x_max,
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


    grid_map = for x <- 0..x_max,
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

  def rotate(%Grid{grid_map: grid_map, x_max: x_max, y_max: y_max}) do
  #   int[,] array = new int[4,4] {
  #     { 1,2,3,4 },
  #     { 5,6,7,8 },
  #     { 9,0,1,2 },
  #     { 3,4,5,6 }
  # };

  # int[,] rotated = RotateMatrix(array, 4);

  # static int[,] RotateMatrix(int[,] matrix, int n) {
  #     int[,] ret = new int[n, n];

  #     for (int i = 0; i < n; ++i) {
  #         for (int j = 0; j < n; ++j) {
  #             ret[i, j] = matrix[n - j - 1, i];
  #         }
  #     }

  #     return ret;
  # }
  rotated_map = for x <- 0..x_max, y <- 0..y_max do
    {{x, y}, Map.get(grid_map, {x, x_max - y - 1})}
  end
  |> Enum.into(%{})

  %Grid{
    grid_map: rotated_map,
    x_max: x_max,
    y_max: y_max

  }
end

end
