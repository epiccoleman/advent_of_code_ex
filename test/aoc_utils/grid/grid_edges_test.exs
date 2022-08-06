defmodule GridEdgesTest do
  use ExUnit.Case

  import AocUtils.Grid2D.Edges

  import AocUtils.Grid2D, only: [to_strs: 1, from_strs: 1]

  test "trim_edges" do
    grid = [
      "####",
      "#.##",
      "##.#",
      "####"
      ] |> from_strs

    trimmed =
      grid
      |> trim_edges()
      |> to_strs()

    assert trimmed == [
      ".#",
      "#."
    ]
  end

  test "edges" do
    grid = [
      "#.#.",
      "#..#",
      "#..#",
      "#..#"
    ] |> from_strs

    assert left_edge(grid) == ["#","#","#","#"]
    assert right_edge(grid) == [".","#","#","#"]
    assert top_edge(grid) == ["#",".","#","."]
    assert bottom_edge(grid) == ["#",".",".","#"]
  end
end
