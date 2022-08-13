defmodule GridTest do
  use ExUnit.Case

  import AocUtils.Grid2D

  alias AocUtils.Grid2D.GridAccessError
  alias AocUtils.Grid2D.InvalidGridMergeError
  alias AocUtils.Grid2D.InvalidGridDimensionsError

  setup_all do
    strs = [
      "#..",
      ".#.",
      "..#"
    ]

    grid = from_strs(strs)

    {:ok, grid: grid, strs: strs}
  end

  describe "new" do
    test "with dimensions and default value" do
      grid = new(2, 3, ".")

      assert grid.x_max == 2
      assert grid.y_max == 3
      assert at(grid, {0,0}) == "."
      assert at(grid, {1,0}) == "."
      assert at(grid, {0,1}) == "."
      assert at(grid, {1,1}) == "."
      assert at(grid, {0,2}) == "."
      assert at(grid, {1,2}) == "."
    end

    test "with default options" do
      grid = new()

      assert grid.x_min == 0
      assert grid.y_min == 0
      assert grid.x_max == 0
      assert grid.y_max == 0

      assert grid.grid_map == %{}
    end

    test "with x_max and y_max" do
      grid = new(x_max: 10, y_max: 12)

      assert grid.x_min == 0
      assert grid.y_min == 0
      assert grid.x_max == 10
      assert grid.y_max == 12

      assert grid.grid_map == %{}
    end

    test "with x_min and y_min" do
      grid = new(x_min: -4, y_min: -3)

      assert grid.x_min == -4
      assert grid.y_min == -3
      assert grid.x_max == 0
      assert grid.y_max == 0

      assert grid.grid_map == %{}
    end

    test "raises InvalidGridDimensionsError if x_min not <= x_max " do
      assert_raise(
        InvalidGridDimensionsError,
        fn -> new(x_min: 10, x_max: 0) end
      )
    end

    test "raises InvalidGridError if y_min not <= y_max " do
      assert_raise(
        InvalidGridDimensionsError,
        fn -> new(y_min: 10, y_max: 0) end
      )
    end

    test "with default value" do
      grid = new(x_max: 1, y_max: 1, default: ".")

      assert length(Map.keys(grid.grid_map)) == 4
      assert at(grid, {0, 0}) == "."
      assert at(grid, {0, 1}) == "."
      assert at(grid, {1, 0}) == "."
      assert at(grid, {1, 1}) == "."
    end

    test "with x_min and y_min and default value" do
      grid = new(x_min: -1, x_max: 1, y_min: -1,  y_max: 1, default: ".")

      assert length(Map.keys(grid.grid_map)) == 9
      assert at(grid, {-1, -1}) == "."
      assert at(grid, {-1, 0}) == "."
      assert at(grid, {-1, 1}) == "."
      assert at(grid, {0, -1}) == "."
      assert at(grid, {0, 0}) == "."
      assert at(grid, {0, 1}) == "."
      assert at(grid, {1, -1}) == "."
      assert at(grid, {1, 0}) == "."
      assert at(grid, {1, 1}) == "."
    end
  end

  describe "update" do
    test "with value" do
      grid = from_rows([
        [1, 2, 3],
        [4, 5, 6]
      ])

      expected_grid = from_rows([
        [1, 4, 3],
        [2, 5, 42]
      ])

      actual_grid =
        grid
        |> update({1, 0}, 4)
        |> update({0, 1}, 2)
        |> update({2, 1}, 42)

      assert actual_grid == expected_grid
    end

    test "update raises GridAccessError when key does not exist" do
      grid = from_rows([
        [1, 2, 3],
        [4, 5, 6]
      ])

      assert_raise(
        GridAccessError,
        "Attempted to access non-existent Grid cell at position: {2, 2}",
        fn -> update(grid, {2, 2}, "foo") end)
    end

    test "with function" do
      grid = from_rows([
        [1, 2, 3],
        [4, 5, 6]
      ])

      expected_grid = from_rows([
        [1, 4, 3],
        [4, 5, 42]
      ])

      actual_grid =
        grid
        |> update({1, 0}, fn v -> v * 2 end)
        |> update({2, 1}, fn v -> v * 7 end)

      assert expected_grid == actual_grid
    end
  end

  describe "merge" do
    setup do
      g1 = new(3, 3, 0)
      g2 = new(3, 3, 1)

      merge_fn = fn _location, _g1_value, g2_value -> g2_value end

      {:ok, g1: g1, g2: g2, merge_fn: merge_fn}
    end

    test "with same dimensions", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid = new(3, 3, 1)

      actual_grid = merge(g1, g2, {0, 0}, merge_fn)
      assert actual_grid == expected_grid
    end

    test "with non-zero offset", %{g1: g1, merge_fn: merge_fn} do
      little_grid = from_rows([
        [2, 2],
        [2, 2]
      ])

      expected_grid = from_rows([
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 2, 2],
        [0, 0, 2, 2],
      ])

      actual_grid = merge(g1, little_grid, {2, 2}, merge_fn)
      assert actual_grid == expected_grid
    end

    test "when g2 does not fit inside g1 raises InvalidGridMergeError", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      assert_raise(
        InvalidGridMergeError,
        "Proposed merge of g2 onto g1 at position {2, 2} is invalid. Merges may not extend the grid.",
        fn -> merge(g1, g2, {2, 2}, merge_fn) end
      )
    end

    test "when negative values in offset raises InvalidGridMergeError", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      assert_raise(
        InvalidGridMergeError,
        "Proposed merge of g2 onto g1 at position {-1, -1} is invalid. Negative values are not allowed in merge locations.",
        fn -> merge(g1, g2, {-1, -1}, merge_fn) end
      )
    end
  end

  test "map" do
    grid = from_rows([
      [1, 2, 3],
      [4, 5, 6]
    ])

    expected_grid = from_rows([
      [2, 3, 4],
      [5, 6, 7]
    ])

    actual_grid = map(grid, fn {_k, value} -> value + 1 end)

    assert actual_grid == expected_grid
  end

  test "map does not affect keys" do
    grid = from_rows([
      [1, 2, 3],
      [4, 5, 6]
    ])
    grid_keys = Map.keys(grid.grid_map)

    expected_grid = from_rows([
      [{{0, 0}, 2}, {{1, 0}, 3}, {{2, 0}, 4}],
      [{{0, 1}, 5}, {{1, 1}, 6}, {{2, 1}, 7}],
    ])

    actual_grid = map(grid, fn {k, v} -> {k, v + 1} end)
    actual_grid_keys = Map.keys(expected_grid.grid_map)

    assert actual_grid == expected_grid
    assert actual_grid_keys == grid_keys
  end

  test "all?" do
    even_grid = from_rows([
      [2, 4, 6],
      [8, 10, 12]
    ])

    not_quite_even_grid = from_rows([
      [2, 4, 6],
      [8, 43, 12]
    ])

    is_even? = fn {_k, v} -> rem(v, 2) == 0 end

    assert all?(even_grid, is_even?)
    assert not all?(not_quite_even_grid, is_even?)
  end

  test "from_rows" do
    grid = from_rows([
      ["#", ".", "."],
      [".", "#", "."],
      [".", ".", "#"]
    ])
    assert grid.x_max == 2
    assert grid.y_max == 2
    assert grid.grid_map == %{
      {0, 0} => "#",
      {0, 1} => ".",
      {0, 2} => ".",
      {1, 0} => ".",
      {1, 1} => "#",
      {1, 2} => ".",
      {2, 0} => ".",
      {2, 1} => ".",
      {2, 2} => "#"
    }
  end

  test "from_cols_simpler" do
    grid = from_cols([
      ["#", "."],
      ["#", "."],
      ["#", "#"]
    ])

    assert grid.x_max == 2
    assert grid.y_max == 1
    assert grid.grid_map == %{
      {0, 0} => "#",
      {0, 1} => ".",
      {1, 0} => "#",
      {1, 1} => ".",
      {2, 0} => "#",
      {2, 1} => "#",
    }
  end

  test "from_cols" do
    grid = from_cols([
      ["#", ".", "."],
      ["#", "#", "."],
      [".", "#", "#"]
    ])

    assert grid.x_max == 2
    assert grid.y_max == 2
    assert grid.grid_map == %{
      {0, 0} => "#",
      {0, 1} => ".",
      {0, 2} => ".",
      {1, 0} => "#",
      {1, 1} => "#",
      {1, 2} => ".",
      {2, 0} => ".",
      {2, 1} => "#",
      {2, 2} => "#"
    }
  end

  test "from_strs", state do
    assert state.grid.x_max == 2
    assert state.grid.y_max == 2
    assert state.grid.grid_map == %{
      {0, 0} => "#",
      {0, 1} => ".",
      {0, 2} => ".",
      {1, 0} => ".",
      {1, 1} => "#",
      {1, 2} => ".",
      {2, 0} => ".",
      {2, 1} => ".",
      {2, 2} => "#"
    }
  end

  test "to_strs", state do
    grid = state.grid

    new_strs = to_strs(grid)

    assert state[:strs] == new_strs
  end

  describe "at!" do
    test "when given position exists", state do
      assert at!(state.grid, {0, 0}) == "#"
      assert at!(state.grid, {0, 1}) == "."
      assert at!(state.grid, {2, 2}) == "#"
    end

    test "raises GridAccessException when given position is not occupied" do
      grid = new(x_max: 3, y_max: 2)

      assert_raise(
        GridAccessError,
        "There is no value at grid position {2, 1}",
        fn -> at!(grid, {2, 1}) end)
    end

    test "raises GridAccessException when given position is outside the grid", state do
      assert_raise(
        GridAccessError,
        "Grid position {2, 42} is outside the bounds of the grid.",
        fn -> at!(state.grid, {2, 42}) end)
    end
  end

  describe "at" do
    test "returns value when given position exists", state do
      assert at(state.grid, {0, 0}) == "#"
      assert at(state.grid, {0, 1}) == "."
      assert at(state.grid, {2, 2}) == "#"
    end

    test "returns nil when given position does not exist" do
      grid = new([x_max: 2, y_max: 2])

      assert at(grid, {0, 0}) == nil
      assert at(grid, {42, 6}) == nil
    end
  end

  test "rows", state do
    assert rows(state.grid) == [["#", ".", "."], [".", "#", "."], [".", ".", "#"]]
  end

  test "row", state do
    assert row(state.grid, 1) == [".", "#", "."]
  end

  test "cols" do
    grid = [
      "##.",
      ".#.",
      ".##"
    ] |> from_strs()

    assert cols(grid) == [["#", ".", "."], ["#", "#", "#"], [".", ".", "#"]]
  end

  test "col" do
    grid = [
      "##.",
      ".#.",
      ".##"
    ] |> from_strs()

    assert col(grid, 2) == [".", ".", "#"]
  end

  test "append_grid" do
    grid = [
      "#.#.",
      "#..#",
      "#..#",
      "#..#"
    ] |> from_strs

    appended = append_grid(grid, grid) |> to_strs()

    assert appended == [
      "#.#.#.#.",
      "#..##..#",
      "#..##..#",
      "#..##..#"
    ]
  end

  test "edge_neighbors" do
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ] |> from_rows

    expected_neighbors = [2, 4, 6, 8]
    actual_neighbors = edge_neighbors(grid, {1, 1}) |> Enum.sort

    assert actual_neighbors == expected_neighbors
  end

  test "edge_neighbors when cell is on edge" do
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ] |> from_rows

    expected_neighbors = [6, 8]
    actual_neighbors = edge_neighbors(grid, {2, 2}) |> Enum.sort

    assert actual_neighbors == expected_neighbors
  end

  test "neighbors" do
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ] |> from_rows()

    expected_neighbors = [1, 2, 3, 4, 6, 7, 8, 9]
    actual_neighbors = neighbors(grid, {1, 1}) |> Enum.sort

    assert actual_neighbors == expected_neighbors
  end

  test "neighbors when cell is on edge" do
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ] |> from_rows()

    expected_neighbors = [5, 6, 8]
    actual_neighbors = neighbors(grid, {2, 2}) |> Enum.sort

    assert actual_neighbors == expected_neighbors
  end

  test "slice_vertically" do
    grid = from_rows([
      [1, 2, 3, 4, 5, 6],
      [7, 8, 9, 4, 9, 8],
    ])

    expected_g_left = from_rows([
      [1, 2, 3],
      [7, 8, 9],
    ])

    expected_g_right = from_rows([
      [5, 6],
      [9, 8],
    ])

    {g_left, g_right} = slice_vertically(grid, 3)

    assert g_left == expected_g_left
    assert g_right == expected_g_right
  end

  test "slice_horizontally" do
    grid = from_rows([
      [1, 2],
      [3, 4],
      [0, 0],
      [5, 6],
      [7, 8],
    ])

    expected_g_up = from_rows([
      [1, 2],
      [3, 4],
    ])

    expected_g_down = from_rows([
      [5, 6],
      [7, 8],
    ])

    {g_up, g_down} = slice_horizontally(grid, 2)

    assert g_up == expected_g_up
    assert g_down == expected_g_down
  end
end
