defmodule GridTest do
  use ExUnit.Case

  import AocUtils.Grid2D

  alias AocUtils.Grid2D.GridAccessError
  alias AocUtils.Grid2D.InvalidGridMergeError

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
    test "new from list of rows" do
      grid = new([
        [1, 2],
        [3, 4]
      ])

      assert at(grid, {0,0}) == 1
      assert at(grid, {1,0}) == 2
      assert at(grid, {0,1}) == 3
      assert at(grid, {1,1}) == 4
    end

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
  end

  describe "update" do
    test "with value" do
      grid = new([
        [1, 2, 3],
        [4, 5, 6]
      ])

      expected_grid = new([
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
      grid = new([
        [1, 2, 3],
        [4, 5, 6]
      ])

      assert_raise(
        GridAccessError,
        "Attempted to access non-existent Grid cell at position: {2, 2}",
        fn -> update(grid, {2, 2}, "foo") end)
    end

    test "with function" do
      grid = new([
        [1, 2, 3],
        [4, 5, 6]
      ])

      expected_grid = new([
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

    test "with no extension", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid = new(3, 3, 1)

      actual_grid = merge(g1, g2, {0, 0}, merge_fn)
      assert actual_grid == expected_grid
    end

    test "with non-zero offset", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      little_grid = new([
        [2, 2],
        [2, 2]
      ])

      expected_grid = new([
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 2, 2],
        [0, 0, 2, 2],
      ])

      actual_grid = merge(g1, little_grid, {2, 2}, merge_fn)
      assert actual_grid == expected_grid
    end

    test "when grids have equal x dimension, positive y offset extends grid downward",
      %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid = new([
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
      ])

      actual_grid = merge(g1, g2, {0, 1}, merge_fn)

      assert actual_grid == expected_grid
    end

    test "when grids have equal y dimension, positive x offset extends grid right",
      %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid = new([
        [0, 0, 1, 1, 1, 1],
        [0, 0, 1, 1, 1, 1],
        [0, 0, 1, 1, 1, 1],
        [0, 0, 1, 1, 1, 1],
      ])

      actual_grid = merge(g1, g2, {2, 0}, merge_fn)

      assert actual_grid == expected_grid
    end

    test "when merge would result in non-rectangular grid raises InvalidMergeError", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      assert_raise(
        InvalidGridMergeError,
        "The proposed merge of the given grids at {2, 2} would result in a non-rectangular grid.",
        fn -> merge(g1, g2, {2, 2}, merge_fn) end
      )
    end

    test "when merge location contains negative values raises InvalidMergeError", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      assert_raise(
        InvalidGridMergeError,
        "Merge positions may not contain negative values.",
        fn -> merge(g1, g2, {-1, -1}, merge_fn) end
      )
    end

    test "when proposed merge would extend grid in both directions, raises InvalidMergeError", %{g1: g1, merge_fn: merge_fn} do
      extending_grid = new(4, 4, 2)

      assert_raise(
        InvalidGridMergeError,
        "Extending merges may extend the grid in only one direction.",
        fn -> merge(g1, extending_grid, {0, 0}, merge_fn) end
      )
    end

    test "when proposed merge would create empty space between the merged grids, raises InvalidMergeError",
      %{g1: g1, g2: g2, merge_fn: merge_fn} do

      assert_raise(
        InvalidGridMergeError,
        "The proposed merge of the given grids at {0, 45} would create empty space in the resulting grid.",
        fn -> merge(g1, g2, {0, 45}, merge_fn) end
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
    even_grid = new([
      [2, 4, 6],
      [8, 10, 12]
    ])

    not_quite_even_grid = new([
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

  describe "at" do
    test "when given position exists", state do
      assert at(state.grid, {0, 0}) == "#"
      assert at(state.grid, {0, 1}) == "."
      assert at(state.grid, {2, 2}) == "#"
    end

    test "raises GridAccessException when given position does not exist", state do
      assert_raise(
        GridAccessError,
        "Attempted to access non-existent Grid cell at position: {2, 42}",
        fn -> at(state.grid, {2, 42}) end)
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
    ] |> new()

    expected_neighbors = [1, 2, 3, 4, 6, 7, 8, 9]
    actual_neighbors = neighbors(grid, {1, 1}) |> Enum.sort

    assert actual_neighbors == expected_neighbors
  end

  test "neighbors when cell is on edge" do
    grid = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ] |> new()

    expected_neighbors = [5, 6, 8]
    actual_neighbors = neighbors(grid, {2, 2}) |> Enum.sort

    assert actual_neighbors == expected_neighbors
  end

  test "slice_vertically" do
    grid = new([
      [1, 2, 3, 4, 5, 6],
      [7, 8, 9, 4, 9, 8],
    ])

    expected_g_left = new([
      [1, 2, 3],
      [7, 8, 9],
    ])

    expected_g_right = new([
      [5, 6],
      [9, 8],
    ])

    {g_left, g_right} = slice_vertically(grid, 3)

    assert g_left == expected_g_left
    assert g_right == expected_g_right
  end

  test "slice_horizontally" do
    grid = new([
      [1, 2],
      [3, 4],
      [0, 0],
      [5, 6],
      [7, 8],
    ])

    expected_g_up = new([
      [1, 2],
      [3, 4],
    ])

    expected_g_down = new([
      [5, 6],
      [7, 8],
    ])

    {g_up, g_down} = slice_horizontally(grid, 2)

    assert g_up == expected_g_up
    assert g_down == expected_g_down
  end
end
