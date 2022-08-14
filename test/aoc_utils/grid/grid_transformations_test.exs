defmodule GridTransformationsTest do
  use ExUnit.Case

  import AocUtils.Grid2D.Transformations

  import AocUtils.Grid2D, only: [new: 1, update: 3, to_strs: 2, to_strs: 1, from_strs: 1]

  describe "flip_horiz" do
    test "flips the grid horizontally" do
      strs = [
        "#..",
        ".##",
        "..#"
      ]

      grid = from_strs(strs)

      flipped =
        grid
        |> flip_horiz()
        |> to_strs()

      assert flipped == [
        "..#",
        "##.",
        "#.."
      ]
    end

    test "works properly on grids with even number of columns" do
      strs = [
        "#...",
        ".#.#",
        "..#.",
      ]

      grid = from_strs(strs)

      flipped =
        grid
        |> flip_horiz()
        |> to_strs()

      assert flipped == [
        "...#",
        "#.#.",
        ".#..",
      ]
    end

    test "works properly on sparse grids" do
      # looks like this:

      #     x _ _
      #     _ x x
      grid =
        new(x_max: 2, y_max: 1)
        |> update({0, 0}, "x")
        |> update({1, 1}, "x")
        |> update({2, 1}, "x")

      flipped =
        grid
        |> flip_horiz()
        |> to_strs("_")

      assert flipped == [
        "__x",
        "xx_",
      ]
    end

    test "works on grids with negative indices" do
      grid =
        new(x_min: -2, x_max: 0, y_max: 1)
        |> update({-2, 0}, "x")
        |> update({-1, 1}, "x")
        |> update({0, 1}, "x")

      flipped =
        grid
        |> flip_horiz()

      assert to_strs(flipped, "_") == [
        "__x",
        "xx_",
      ]

      assert flipped.x_min == -2
      assert flipped.x_max == 0
      assert flipped.y_max == 1
      assert flipped.y_min == 0
    end
  end

  # #..
  # .#.
  # ..#
  describe "flip_vert" do
    test "flips the grid vertically" do
      grid = [
        "##.",
        ".#.",
        "..#"] |> from_strs

      flipped =
        grid
        |> flip_vert()
        |> to_strs()

      assert flipped == [
        "..#",
        ".#.",
        "##."
      ]
    end

    test "works properly on grids with even number of rows" do
      strs = [
        "#...",
        ".#.#",
        "..#.",
        ".###"
      ]

      grid = from_strs(strs)

      flipped =
        grid
        |> flip_vert()
        |> to_strs()

      assert flipped == [
        ".###",
        "..#.",
        ".#.#",
        "#...",
      ]
    end

    test "works properly on sparse grids" do
      # looks like this:

      #     x _ _
      #     _ x x
      grid =
        new(x_max: 2, y_max: 1)
        |> update({0, 0}, "x")
        |> update({1, 1}, "x")
        |> update({2, 1}, "x")

      flipped =
        grid
        |> flip_vert()
        |> to_strs("_")

      assert flipped == [
        "_xx",
        "x__",
      ]
    end

    test "works on grids with negative indices" do
      # looks like this:

      # x _ _
      # _ x x
      # x _ x

      grid =
        new(x_min: -2, x_max: 0, y_min: -2, y_max: 0)
        |> update({-2, -2}, "x")
        |> update({-1, -1}, "x")
        |> update({0, -1}, "x")
        |> update({-2, 0}, "x")
        |> update({0, 0}, "x")

      flipped =
        grid
        |> flip_vert()

      assert to_strs(flipped, "_") == [
        "x_x",
        "_xx",
        "x__",
      ]

      assert flipped.x_min == -2
      assert flipped.x_max == 0
      assert flipped.y_max == 0
      assert flipped.y_min == -2
    end
  end

  test "rotations" do
    grid = [
      "**",
      ".."
    ] |> from_strs()

    rotated90 =
      grid
      |> rotate()
      |> to_strs()

    assert rotated90 == [
      ".*",
      ".*"
    ]

    rotated180 =
      grid
      |> rotate()
      |> rotate()
      |> to_strs()

    assert rotated180 == [
      "..",
      "**"
    ]

    rotated270 =
      grid
      |> rotate()
      |> rotate()
      |> rotate()
      |> to_strs()

    assert rotated270 == [
      "*.",
      "*."
    ]
  end

  test "rotated bigger" do
    grid = [
      "##########",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
    ] |> from_strs()

    rotated90 =
      grid
      |> rotate()
      |> to_strs()

    assert rotated90 == [
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      ".........#",
      "##########",
    ]
  end

  test "orient_edge_top" do
    grid = [
      "#.#.",
      "#..#",
      "#..#",
      "#..#"
    ] |> from_strs

    reoriented =
      grid
      |> orient_edge_top(["#","#","#","."])
      |> to_strs()

    assert reoriented == [
      "###.",
      "...#",
      "....",
      "####"
    ]
  end

  test "orient_edge_to_direction" do
    grid = [
      "#.#.",
      "#..#",
      "#..#",
      "#..#"
    ] |> from_strs

    reoriented =
      grid
      |> orient_edge_to_direction(["#",".","#","."], :right)
      |> to_strs()

    assert reoriented == [
      "####",
      "....",
      "...#",
      "###."
    ]
  end

end
