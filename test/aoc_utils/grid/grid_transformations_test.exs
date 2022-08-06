defmodule GridTransformationsTest do
  use ExUnit.Case

  import AocUtils.Grid2D.Transformations

  import AocUtils.Grid2D, only: [to_strs: 1, from_strs: 1]

  test "flip_horiz" do
    strs = [
      "#..",
      ".#.",
      "..#"
    ]

    grid = from_strs(strs)

    flipped =
      grid
      |> flip_horiz()
      |> to_strs()

    assert flipped == [
      "..#",
      ".#.",
      "#.."
    ]
  end

  # #..
  # .#.
  # ..#
  test "flip_vert" do
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
