defmodule GridTest do
  use ExUnit.Case

  import AocUtils.Grid2D

  require Integer
  alias AocUtils.Grid2D
  alias AocUtils.Grid2D.GridAccessError
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
      assert at(grid, {0, 0}) == "."
      assert at(grid, {1, 0}) == "."
      assert at(grid, {0, 1}) == "."
      assert at(grid, {1, 1}) == "."
      assert at(grid, {0, 2}) == "."
      assert at(grid, {1, 2}) == "."
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
      grid = new(x_min: -1, x_max: 1, y_min: -1, y_max: 1, default: ".")

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
      grid =
        from_rows([
          [1, 2, 3],
          [4, 5, 6]
        ])

      expected_grid =
        from_rows([
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

    test "with function" do
      grid =
        new(x_max: 2, y_max: 2)
        |> update({1, 1}, "i'll be replaced")
        |> update({2, 1}, "i'll be replaced")

      actual_grid =
        grid
        |> update({1, 1}, fn _ -> "foo" end, nil)
        |> update({2, 1}, fn v -> String.upcase(v) end, nil)

      assert at(actual_grid, {1, 1}) == "foo"
      assert at(actual_grid, {2, 1}) == "I'LL BE REPLACED"
    end

    test "inserts default when position is unoccupied" do
      grid = new(x_max: 2, y_max: 2)

      actual_grid = update(grid, {1, 1}, fn _ -> 97 end, 1)

      assert at(actual_grid, {1, 1}) == 1
    end

    test "uses update fn when position is occupied" do
      grid =
        new(x_max: 2, y_max: 2)
        |> update({1, 1}, "i'll be replaced")

      actual_grid = update(grid, {1, 1}, fn _ -> 97 end, 1)

      assert at(actual_grid, {1, 1}) == 97
    end

    test "does nothing when position is outside bounds of grid" do
      grid = new(x_max: 2, y_max: 2)

      actual = update(grid, {3, 3}, 42)

      assert actual == grid
    end
  end

  describe "update!" do
    test "raises GridAccessError when position does not exist" do
      grid = new(x_max: 2, y_max: 2)

      assert_raise(
        GridAccessError,
        "Attempted to access non-existent Grid cell at position: {2, 2}",
        fn -> update!(grid, {2, 2}, "foo") end
      )
    end

    test "on sparse grid raises GridAccessError when position is out of bounds" do
      grid = new(x_max: 2, y_max: 2)

      assert_raise(
        GridAccessError,
        "Grid position {3, 3} is outside the bounds of the grid.",
        fn -> update!(grid, {3, 3}, "foo") end
      )

      false
    end

    test "with function" do
      grid =
        from_rows([
          [1, 2, 3],
          [4, 5, 6]
        ])

      expected_grid =
        from_rows([
          [1, 4, 3],
          [4, 5, 42]
        ])

      actual_grid =
        grid
        |> update!({1, 0}, fn v -> v * 2 end)
        |> update!({2, 1}, fn v -> v * 7 end)

      assert expected_grid == actual_grid
    end

    test "with value" do
      grid =
        from_rows([
          [1, 2, 3],
          [4, 5, 6]
        ])

      expected_grid =
        from_rows([
          [1, "foo", 3],
          [4, 5, 42]
        ])

      actual_grid =
        grid
        |> update!({1, 0}, "foo")
        |> update!({2, 1}, 42)

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
      little_grid =
        from_rows([
          [2, 2],
          [2, 2]
        ])

      expected_grid =
        from_rows([
          [0, 0, 0, 0],
          [0, 0, 0, 0],
          [0, 0, 2, 2],
          [0, 0, 2, 2]
        ])

      actual_grid = merge(g1, little_grid, {2, 2}, merge_fn)
      assert actual_grid == expected_grid
    end

    test "can extend the grid to the right", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid =
        from_rows([
          [0, 0, 0, 0, 1, 1, 1, 1],
          [0, 0, 0, 0, 1, 1, 1, 1],
          [0, 0, 0, 0, 1, 1, 1, 1],
          [0, 0, 0, 0, 1, 1, 1, 1]
        ])

      actual_grid = merge(g1, g2, {4, 0}, merge_fn)

      assert actual_grid == expected_grid
    end

    test "can extend the grid to the left", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid_rows = [
        [1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0]
      ]

      actual_grid = merge(g1, g2, {-4, 0}, merge_fn)
      actual_grid_rows = actual_grid |> rows()

      assert actual_grid.x_min == -4
      assert actual_grid.x_max == 3
      assert actual_grid.y_min == 0
      assert actual_grid.y_max == 3

      assert actual_grid_rows == expected_grid_rows
    end

    test "can extend the grid down", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid =
        from_rows([
          [0, 0, 0, 0],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [1, 1, 1, 1]
        ])

      actual_grid = merge(g1, g2, {0, 3}, merge_fn)

      assert actual_grid == expected_grid
    end

    test "can extend the grid up", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid_rows = [
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ]

      actual_grid = merge(g1, g2, {0, -2}, merge_fn)
      actual_grid_rows = actual_grid |> rows()

      assert actual_grid.x_min == 0
      assert actual_grid.x_max == 3
      assert actual_grid.y_min == -2
      assert actual_grid.y_max == 3

      assert actual_grid_rows == expected_grid_rows
    end

    test "extends the grid in both positive directions", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid =
        from_rows([
          [0, 0, 0, 0, nil, nil, nil],
          [0, 0, 0, 0, nil, nil, nil],
          [0, 0, 0, 0, nil, nil, nil],
          [0, 0, 0, 1, 1, 1, 1],
          [nil, nil, nil, 1, 1, 1, 1],
          [nil, nil, nil, 1, 1, 1, 1],
          [nil, nil, nil, 1, 1, 1, 1]
        ])

      actual_grid = merge(g1, g2, {3, 3}, merge_fn)

      assert expected_grid == actual_grid
    end

    test "extends the grid in both negative directions", %{g1: g1, g2: g2, merge_fn: merge_fn} do
      expected_grid_rows = [
        [1, 1, 1, 1, nil],
        [1, 1, 1, 1, nil],
        [1, 1, 1, 1, nil],
        [1, 1, 1, 1, 0],
        [nil, 0, 0, 0, 0],
        [nil, 0, 0, 0, 0],
        [nil, 0, 0, 0, 0]
      ]

      actual_grid = merge(g1, g2, {-1, -3}, merge_fn)
      actual_grid_rows = rows(actual_grid)

      assert expected_grid_rows == actual_grid_rows
      assert actual_grid.x_min == -1
      assert actual_grid.x_max == 3
      assert actual_grid.y_min == -3
      assert actual_grid.y_max == 3
    end
  end

  test "map" do
    grid =
      from_rows([
        [1, 2, 3],
        [4, 5, 6]
      ])

    expected_grid =
      from_rows([
        [2, 3, 4],
        [5, 6, 7]
      ])

    actual_grid = map(grid, fn {_k, value} -> value + 1 end)

    assert actual_grid == expected_grid
  end

  test "map on sparse grid transforms only existing keys" do
    grid =
      new(x_max: 2, y_max: 2)
      |> update({1, 1}, 2)
      |> update({2, 2}, 4)

    actual_grid = map(grid, fn {_, v} -> v * 2 end)

    assert length(Map.keys(actual_grid.grid_map)) == length(Map.keys(actual_grid.grid_map))
    assert at(actual_grid, {1, 1}) == 4
    assert at(actual_grid, {2, 2}) == 8
  end

  test "map does not affect keys" do
    grid =
      from_rows([
        [1, 2, 3],
        [4, 5, 6]
      ])

    grid_keys = Map.keys(grid.grid_map)

    expected_grid =
      from_rows([
        [{{0, 0}, 2}, {{1, 0}, 3}, {{2, 0}, 4}],
        [{{0, 1}, 5}, {{1, 1}, 6}, {{2, 1}, 7}]
      ])

    actual_grid = map(grid, fn {k, v} -> {k, v + 1} end)
    actual_grid_keys = Map.keys(expected_grid.grid_map)

    assert actual_grid == expected_grid
    assert actual_grid_keys == grid_keys
  end

  describe "delete" do
    test "deletes the given location from the grid" do
      grid =
        from_rows([
          [1, 2],
          [3, 4]
        ])

      actual = delete(grid, {1, 1})

      expected = %Grid2D{
        grid_map: %{
          {0, 0} => 1,
          {1, 0} => 2,
          {0, 1} => 3
        },
        x_min: 0,
        x_max: 1,
        y_min: 0,
        y_max: 1
      }

      assert actual == expected
    end

    test "returns the grid unmodified if the given location does not exist" do
      grid =
        from_rows([
          [1, 2],
          [3, 4]
        ])

      actual = delete(grid, {21, 12})

      assert actual == grid
    end
  end

  test "find_locs" do
    grid =
      from_rows([
        [1, 2, 3],
        [4, 5, 6]
      ])

    expected_locs_even = [
      {0, 1},
      {1, 0},
      {2, 1}
    ]

    expected_locs_odd = [
      {0, 0},
      {1, 1},
      {2, 0}
    ]

    even_fn = fn {_, v} -> Integer.is_even(v) end
    odd_fn = fn {_, v} -> Integer.is_odd(v) end

    assert find_locs(grid, even_fn) == expected_locs_even
    assert find_locs(grid, odd_fn) == expected_locs_odd
  end

  test "matching_locs" do
    grid =
      from_rows([
        [2, 1, 2],
        [1, 2, 1]
      ])

    expected_locs_one = [
      {0, 1},
      {1, 0},
      {2, 1}
    ]

    expected_locs_two = [
      {0, 0},
      {1, 1},
      {2, 0}
    ]

    assert matching_locs(grid, 1) == expected_locs_one
    assert matching_locs(grid, 2) == expected_locs_two
  end

  test "all?" do
    even_grid =
      from_rows([
        [2, 4, 6],
        [8, 10, 12]
      ])

    not_quite_even_grid =
      from_rows([
        [2, 4, 6],
        [8, 43, 12]
      ])

    is_even? = fn {_k, v} -> rem(v, 2) == 0 end

    assert all?(even_grid, is_even?)
    assert not all?(not_quite_even_grid, is_even?)
  end

  describe "from_rows" do
    test "from_rows" do
      grid =
        from_rows([
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

    test "does not create keys in the grid map for nils" do
      grid =
        from_rows([
          ["#", nil, nil],
          [".", nil, "."],
          [nil, nil, "#"]
        ])

      assert grid.x_max == 2
      assert grid.y_max == 2

      assert grid.grid_map == %{
               {0, 0} => "#",
               {0, 1} => ".",
               {2, 1} => ".",
               {2, 2} => "#"
             }
    end

    test "when given ignore_value does not create keys in the map for that value" do
      grid =
        from_rows(
          [
            ["#", ".", "."],
            [".", "#", "."],
            [".", ".", "#"]
          ],
          "."
        )

      assert grid.x_max == 2
      assert grid.y_max == 2

      assert grid.grid_map == %{
               {0, 0} => "#",
               {1, 1} => "#",
               {2, 2} => "#"
             }
    end
  end

  describe "from_cols" do
    test "simple input" do
      grid =
        from_cols([
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
               {2, 1} => "#"
             }
    end

    test "when not given ignore_value ignores nils" do
      grid =
        from_cols([
          ["#", nil, nil],
          ["#", "#", nil],
          [nil, "#", "#"]
        ])

      assert grid.x_max == 2
      assert grid.y_max == 2

      assert grid.grid_map == %{
               {0, 0} => "#",
               {1, 0} => "#",
               {1, 1} => "#",
               {2, 1} => "#",
               {2, 2} => "#"
             }
    end

    test "when given ignore_value ignores that value in the input" do
      grid =
        from_cols(
          [
            ["#", ".", "."],
            ["#", "#", "."],
            [".", "#", "#"]
          ],
          "."
        )

      assert grid.x_max == 2
      assert grid.y_max == 2

      assert grid.grid_map == %{
               {0, 0} => "#",
               {1, 0} => "#",
               {1, 1} => "#",
               {2, 1} => "#",
               {2, 2} => "#"
             }
    end

    test "from_columns simple" do
      grid =
        from_columns([
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
  end

  describe "from_strs" do
    test "adds the characters of the given strings", state do
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

    test "ignores a single ignore char if given" do
      expected =
        new(x_max: 2, y_max: 2)
        |> update({0, 0}, "#")
        |> update({1, 1}, "#")
        |> update({2, 2}, "#")

      actual =
        from_strs(
          ["#..", ".#.", "..#"],
          ignore: "."
        )

      assert expected == actual
    end

    test "ignores a list of ignore chars if given" do
      test_grid_strs = [
        "..A",
        ".B#",
        "@C."
      ]

      expected =
        new(x_max: 2, y_max: 2)
        |> update({2, 0}, "A")
        |> update({1, 1}, "B")
        |> update({1, 2}, "C")

      actual =
        from_strs(
          test_grid_strs,
          ignore: [".", "#", "@"]
        )

      assert expected == actual
    end

    test "raises if the user passes nonsense for ignore" do
      test_grid_strs = [
        "..A",
        ".B#",
        "@C."
      ]

      assert_raise(ArgumentError, fn -> from_strs(test_grid_strs, ignore: %{hey: "you guys"}) end)
    end

    test "raises if the given strings are not all of the same length" do
      test_grid_strs = [
        "..#",
        "..#",
        ".."
      ]

      assert_raise(ArgumentError, fn -> from_strs(test_grid_strs) end)
    end
  end

  describe "from_list" do
    test "creates a simple grid from a list of values" do
      expected =
        new(x_max: 2, y_max: 2)
        |> update({0, 0}, "#")
        |> update({1, 1}, "#")
        |> update({2, 2}, "#")

      actual =
        [
          {{0, 0}, "#"},
          {{1, 1}, "#"},
          {{2, 2}, "#"}
        ]
        |> from_list()

      assert expected == actual
    end

    test "raises ArgumentError if input list is malformed" do
      input_list = [
        {1, 2},
        {{2, 1}, 2}
      ]

      assert_raise(ArgumentError, fn -> from_list(input_list) end)
    end

    test "sets dimensions correctly" do
      actual =
        [
          {{3, 4}, "F"},
          {{37, 12}, "0"},
          {{3, 19}, "F"}
        ]
        |> from_list()

      expected = %Grid2D{
        grid_map: %{
          {3, 4} => "F",
          {37, 12} => "0",
          {3, 19} => "F"
        },
        x_min: 3,
        x_max: 37,
        y_min: 4,
        y_max: 19
      }

      assert actual == expected
    end
  end

  describe "to_strs" do
    test "converts the grid to a list of row strings", state do
      grid = state.grid

      new_strs = to_strs(grid)

      assert state[:strs] == new_strs
    end

    test "inserts a space for non-occupied positions" do
      grid =
        new(x_max: 2, y_max: 2)
        |> update({0, 0}, "x")
        |> update({1, 0}, "x")
        |> update({0, 1}, "x")
        |> update({2, 1}, "x")
        |> update({1, 2}, "x")
        |> update({2, 2}, "x")

      expected_strs = [
        "xx ",
        "x x",
        " xx"
      ]

      actual_strs = to_strs(grid)

      assert actual_strs == expected_strs
    end

    test "when given a default value inserts it for non-occupied positions" do
      grid =
        new(x_max: 2, y_max: 2)
        |> update({0, 0}, "x")
        |> update({1, 0}, "x")
        |> update({0, 1}, "x")
        |> update({2, 1}, "x")
        |> update({1, 2}, "x")
        |> update({2, 2}, "x")

      expected_strs = [
        "xx.",
        "x.x",
        ".xx"
      ]

      actual_strs = to_strs(grid, ".")

      assert actual_strs == expected_strs
    end
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
        fn -> at!(grid, {2, 1}) end
      )
    end

    test "raises GridAccessException when given position is outside the grid", state do
      assert_raise(
        GridAccessError,
        "Grid position {2, 42} is outside the bounds of the grid.",
        fn -> at!(state.grid, {2, 42}) end
      )
    end
  end

  describe "at" do
    test "returns value when given position exists", state do
      assert at(state.grid, {0, 0}) == "#"
      assert at(state.grid, {0, 1}) == "."
      assert at(state.grid, {2, 2}) == "#"
    end

    test "returns nil when given position does not exist" do
      grid = new(x_max: 2, y_max: 2)

      assert at(grid, {0, 0}) == nil
      assert at(grid, {42, 6}) == nil
    end
  end

  describe "rows" do
    test "returns a list of the grid's rows", state do
      assert rows(state.grid) == [["#", ".", "."], [".", "#", "."], [".", ".", "#"]]
    end

    test "substitutes nil if a position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({0, 0}, :foo)
        |> update({1, 1}, 42)

      expected_rows = [
        [:foo, nil],
        [nil, 42]
      ]

      assert rows(grid) == expected_rows
    end

    test "when provided default, substitutes default when position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({0, 0}, :foo)
        |> update({1, 1}, 42)

      expected_rows = [
        [:foo, 2112],
        [2112, 42]
      ]

      assert rows(grid, 2112) == expected_rows
    end
  end

  describe "row" do
    test "returns the row", state do
      assert row(state.grid, 1) == [".", "#", "."]
    end

    test "substitutes nil if a position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({0, 0}, :foo)

      expected_row = [:foo, nil]

      assert row(grid, 0) == expected_row
    end

    test "when provided default, substitutes default when position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 1}, 42)

      expected_row = [2112, 42]

      assert row(grid, 1, 2112) == expected_row
    end
  end

  describe "cols" do
    test "returns a list of the grid's columns" do
      grid =
        [
          "##.",
          ".#.",
          ".##"
        ]
        |> from_strs()

      assert cols(grid) == [["#", ".", "."], ["#", "#", "#"], [".", ".", "#"]]
    end

    test "substitutes nil if a position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 0}, :foo)
        |> update({1, 1}, 42)

      expected_cols = [
        [nil, nil],
        [:foo, 42]
      ]

      assert cols(grid) == expected_cols
    end

    test "when provided default, substitutes default when position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 0}, :foo)
        |> update({1, 1}, 42)

      expected_cols = [
        [2112, 2112],
        [:foo, 42]
      ]

      assert cols(grid, 2112) == expected_cols
    end
  end

  describe "col" do
    test "returns the requested column" do
      grid =
        [
          "##.",
          ".#.",
          ".##"
        ]
        |> from_strs()

      assert col(grid, 2) == [".", ".", "#"]
    end

    test "substitutes nil if a position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({0, 0}, :foo)

      expected_col = [:foo, nil]

      assert col(grid, 0) == expected_col
    end

    test "when provided default, substitutes default when position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 1}, 42)

      expected_col = [2112, 42]

      assert col(grid, 1, 2112) == expected_col
    end
  end

  describe "columns" do
    test "on complete grid returns columns" do
      grid =
        [
          "##.",
          ".#.",
          ".##"
        ]
        |> from_strs()

      assert columns(grid) == [["#", ".", "."], ["#", "#", "#"], [".", ".", "#"]]
    end

    test "substitutes nil if a position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 0}, :foo)
        |> update({1, 1}, 42)

      expected_cols = [
        [nil, nil],
        [:foo, 42]
      ]

      assert columns(grid) == expected_cols
    end

    test "when provided default, substitutes default when position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 0}, :foo)
        |> update({1, 1}, 42)

      expected_cols = [
        [2112, 2112],
        [:foo, 42]
      ]

      assert columns(grid, 2112) == expected_cols
    end
  end

  describe "column" do
    test "returns the requested column" do
      grid =
        [
          "##.",
          ".#.",
          ".##"
        ]
        |> from_strs()

      assert column(grid, 2) == [".", ".", "#"]
    end

    test "substitutes nil if a position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({0, 0}, :foo)

      expected_col = [:foo, nil]

      assert column(grid, 0) == expected_col
    end

    test "when provided default, substitutes default when position is unoccupied" do
      grid =
        new(x_max: 1, y_max: 1)
        |> update({1, 1}, 42)

      expected_col = [2112, 42]

      assert column(grid, 1, 2112) == expected_col
    end
  end

  describe "translate" do
    test "shifts the grid's locations to a new origin" do
      grid =
        new(x_min: -2, x_max: 0, y_min: -2, y_max: 0)
        |> update({0, 0}, 1)
        |> update({-1, -1}, 2)
        |> update({-2, -2}, 4)

      actual = translate(grid, {0, 0})

      expected =
        from_rows([
          [4, nil, nil],
          [nil, 2, nil],
          [nil, nil, 1]
        ])

      assert actual == expected
    end

    test "shifts the grid's locations negative" do
      grid =
        from_rows([
          [4, nil, nil],
          [nil, 2, nil],
          [nil, nil, 1]
        ])

      actual = translate(grid, {-2, -2})

      expected =
        new(x_min: -2, x_max: 0, y_min: -2, y_max: 0)
        |> update({0, 0}, 1)
        |> update({-1, -1}, 2)
        |> update({-2, -2}, 4)

      assert actual == expected
    end
  end

  test "append_grid" do
    grid =
      [
        "#.#.",
        "#..#",
        "#..#",
        "#..#"
      ]
      |> from_strs

    appended = append_grid(grid, grid) |> to_strs()

    assert appended == [
             "#.#.#.#.",
             "#..##..#",
             "#..##..#",
             "#..##..#"
           ]
  end

  test "edge_neighbors" do
    grid =
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
      |> from_rows

    expected_neighbors = [2, 4, 6, 8]
    actual_neighbors = edge_neighbors(grid, {1, 1}) |> Enum.sort()

    assert actual_neighbors == expected_neighbors
  end

  test "edge_neighbors when cell is on edge" do
    grid =
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
      |> from_rows

    expected_neighbors = [6, 8]
    actual_neighbors = edge_neighbors(grid, {2, 2}) |> Enum.sort()

    assert actual_neighbors == expected_neighbors
  end

  test "neighbors" do
    grid =
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
      |> from_rows()

    expected_neighbors = [1, 2, 3, 4, 6, 7, 8, 9]
    actual_neighbors = neighbors(grid, {1, 1}) |> Enum.sort()

    assert actual_neighbors == expected_neighbors
  end

  test "neighbors when cell is on edge" do
    grid =
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
      |> from_rows()

    expected_neighbors = [5, 6, 8]
    actual_neighbors = neighbors(grid, {2, 2}) |> Enum.sort()

    assert actual_neighbors == expected_neighbors
  end

  describe "slice" do
    test "slice_vertically" do
      grid =
        from_rows([
          [1, 2, 3, 4, 5, 6],
          [7, 8, 9, 4, 9, 8]
        ])

      expected_g_left =
        from_rows([
          [1, 2, 3],
          [7, 8, 9]
        ])

      expected_g_right =
        from_rows([
          [5, 6],
          [9, 8]
        ])

      {g_left, g_right} = slice_vertically(grid, 3)

      assert g_left == expected_g_left
      assert g_right == expected_g_right
    end

    test "slice_horizontally" do
      grid =
        from_rows([
          [1, 2],
          [3, 4],
          [0, 0],
          [5, 6],
          [7, 8]
        ])

      expected_g_up =
        from_rows([
          [1, 2],
          [3, 4]
        ])

      expected_g_down =
        from_rows([
          [5, 6],
          [7, 8]
        ])

      {g_up, g_down} = slice_horizontally(grid, 2)

      assert g_up == expected_g_up
      assert g_down == expected_g_down
    end
  end

  describe "extract_piece" do
    test "extracts rectangles from the grid, and translates it to default origin" do
      source_grid =
        from_rows([
          [1, 2, 3, 4, 5, 6],
          [7, 8, 9, 1, 2, 3],
          [9, 0, 1, 2, 5, 8],
          [2, 1, 1, 2, 0, 8]
        ])

      expected_1 =
        from_rows([
          [1, 2, 3],
          [7, 8, 9]
        ])

      expected_2 =
        from_rows([
          [5, 8],
          [0, 8]
        ])

      expected_3 =
        from_rows([
          [2, 1, 1, 2]
        ])

      expected_4 =
        from_rows([
          [6],
          [3],
          [8],
          [8]
        ])

      actual_1 = extract_piece(source_grid, {0, 0}, {2, 1})
      actual_2 = extract_piece(source_grid, {4, 2}, {5, 3})
      actual_3 = extract_piece(source_grid, {0, 3}, {3, 3})
      actual_4 = extract_piece(source_grid, {5, 0}, {5, 3})

      assert actual_1 == expected_1
      assert actual_2 == expected_2
      assert actual_3 == expected_3
      assert actual_4 == expected_4
    end

    test "preserves original coordinates when preserve_origin true" do
      source_grid =
        from_rows([
          [1, 2, 3, 4, 5, 6],
          [7, 8, 9, 1, 2, 3],
          [9, 0, 1, 2, 5, 8],
          [2, 1, 1, 2, 0, 8]
        ])

      expected_1 =
        from_rows([
          [5, 8],
          [0, 8]
        ])
        |> translate({4, 2})

      expected_2 =
        from_rows([
          [2, 1, 1, 2]
        ])
        |> translate({0, 3})

      expected_3 =
        from_rows([
          [6],
          [3],
          [8],
          [8]
        ])
        |> translate({5, 0})

      actual_1 = extract_piece(source_grid, {4, 2}, {5, 3}, preserve_origin: true)
      actual_2 = extract_piece(source_grid, {0, 3}, {3, 3}, preserve_origin: true)
      actual_3 = extract_piece(source_grid, {5, 0}, {5, 3}, preserve_origin: true)

      assert actual_1 == expected_1
      assert actual_2 == expected_2
      assert actual_3 == expected_3
    end

    test "raises GridAccessError if rectangle reaches outside the bounds of the grid" do
      source_grid =
        from_rows([
          [1, 2, 3, 4, 5, 6],
          [7, 8, 9, 1, 2, 3],
          [9, 0, 1, 2, 5, 8],
          [2, 1, 1, 2, 0, 8]
        ])

      assert_raise(GridAccessError, fn -> extract_piece(source_grid, {3, 2}, {6, 7}) end)
    end
  end

  describe "grid size" do
    test "x_size returns the horizontal size of the grid" do
      test_grid =
        from_rows([
          [1, 2, 3, 4, 5, 6],
          [7, 8, 9, 1, 2, 3],
          [9, 0, 1, 2, 5, 8],
          [2, 1, 1, 2, 0, 8]
        ])

      assert x_size(test_grid) == 6
    end

    test "y_size returns the vertical size of the grid" do
      test_grid =
        from_rows([
          [1, 2, 3, 4, 5, 6],
          [7, 8, 9, 1, 2, 3],
          [9, 0, 1, 2, 5, 8],
          [2, 1, 1, 2, 0, 8]
        ])

      assert y_size(test_grid) == 4
    end

    test "size works even if one side isn't 0" do
      test_grid = new(x_min: 1, y_min: 1, x_max: 3, y_max: 3)
      assert x_size(test_grid) == 3
      assert y_size(test_grid) == 3
    end

    test "size works even with negatives" do
      test_grid = new(x_min: -1, y_min: -1, x_max: 1, y_max: 1)
      assert x_size(test_grid) == 3
      assert y_size(test_grid) == 3
    end

    test "size works even if you do something dumb and weird" do
      test_grid = new(x_min: -1, y_min: 1, x_max: 0, y_max: 12)
      assert x_size(test_grid) == 2
      assert y_size(test_grid) == 12
    end
  end

  test "within_boundaries?" do
    test_grid =
      from_rows([
        [1, 2, 3, 4],
        [7, 8, 9, 1],
        [9, 0, 1, 2],
        [2, 1, 1, 2]
      ])

    assert within_boundaries?(test_grid, {1, 1})
    assert within_boundaries?(test_grid, {0, 0})
    assert within_boundaries?(test_grid, {3, 3})
    assert not within_boundaries?(test_grid, {-1, 0})
    assert not within_boundaries?(test_grid, {5, 0})
    assert not within_boundaries?(test_grid, {0, 7})
    assert not within_boundaries?(test_grid, {19, 72})
  end
end
