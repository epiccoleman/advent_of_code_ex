defmodule Day24Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils
  import Checkov

  import Day24

  test "sample simple" do
    input = [
      "e",
      "w",
      "se",
      "sw",
      "ne",
      "nw",
    ]
    assert part_1(input) == 6
  end

  test "sample" do
    input = [
      "esew",
      "nwwswee"
    ]
    assert part_1(input) == 2
  end

  test "sample 1a" do
    input = [
      "esew",
      "nwwswee",
      "esew"
    ]
    assert part_1(input) == 1
  end


  test "sample 2" do
    input = FileUtils.get_file_as_strings("test/day24/small-input.txt")
    assert part_1(input) == 10
  end

  test "count_neighbors" do
    tile_map = [
      "e",
      "w",
    ] |> input_to_tile_map()

    assert count_neighbors({0, 0, 0}, tile_map) == %{"black" => 2, "white" => 4}
  end

  test "next_tile_state black 0 black neihgbors" do
    tile_map = [
      "ew"
    ] |> input_to_tile_map()

    assert next_tile_state({0,0,0}, tile_map) == "white"
  end

  test "next_tile_state black 1 black neihgbors" do
    tile_map = [
      "ew",
      "w"
    ] |> input_to_tile_map()

    assert next_tile_state({0,0,0}, tile_map) == "black"
  end

  test "next_tile_state black 3 black neihgbors" do
    tile_map = [
      "ew",
      "w",
      "ne",
      "e"
    ] |> input_to_tile_map()

    assert next_tile_state({0,0,0}, tile_map) == "white"
  end

  test "next_tile_state white 2 black neihgbors" do
    tile_map = [
      "e",
      "w"
    ] |> input_to_tile_map()

    assert next_tile_state({0,0,0}, tile_map) == "black"

  end

  test "update_tiles white 2 black neihgbors unset" do
    tile_map = [
      "ne",
      "e"
    ] |> input_to_tile_map()

    updated = update_tiles(tile_map)

    target = Map.get(updated, {2, -1, -1})

    assert Map.get(tile_map, {2, -1, -1}, "unset") == "unset"
    assert target == "black"
  end

  data_test "Part 2 sample" do
    tile_map = FileUtils.get_file_as_strings("test/day24/small-input.txt") |> input_to_tile_map()

    updated = do_updates(tile_map, count)
    black = Enum.count(updated, fn {_, state} -> state == "black" end)

    assert black == result

    where [
      [:count, :result],
      [1, 15],
      [2, 12],
      [3, 25],
      [4, 14],
      [5, 23],
      [6, 28],
      [7, 41],
      [8, 37],
      [9, 49],
      [10, 37]
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("test/day24/input.txt")
    assert part_1(input) == 354
  end

  @tag slow: true
  @tag timeout: :infinity
  test "Part 2" do
    input = FileUtils.get_file_as_strings("test/day24/input.txt")
    assert Day24.part_2(input) == 3608
  end
end
