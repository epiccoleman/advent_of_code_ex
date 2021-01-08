defmodule Day20Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  import Day20
  alias Day20.Grid

  test "get_neighbor_in_direction" do
    input = File.read!("test/day20/test_input.txt")
    tile_map = input_to_map(input)
    neighbor_map = neighbor_map(tile_map)

    assert get_neighbor_in_direction(tile_map, 1111, neighbor_map, :right) == 2222
    assert get_neighbor_in_direction(tile_map, 1111, neighbor_map, :bottom) == 4444
    assert get_neighbor_in_direction(tile_map, 2222, neighbor_map, :right) == 3333
    assert get_neighbor_in_direction(tile_map, 2222, neighbor_map, :left) == 1111
  end

  test "assemble_image" do
    input = File.read!("test/day20/small_input.txt")
    tile_map = input_to_map(input)
    neighbor_map = neighbor_map(tile_map)

    image = assemble_image(tile_map)

    corners = corners(neighbor_map) |> Enum.map(fn {id, _} -> id end)
    edges = neighbor_map |> Enum.filter(fn {_id, l} -> length(l) == 3 end)  |> Enum.map(fn {id, _} -> id end)

    assert image.layout[{0, 0}] in corners
    assert image.layout[{2, 2}] in corners
    assert image.layout[{0, 2}] in corners
    assert image.layout[{2, 0}] in corners
    assert image.layout[{0, 1}] in edges
    assert image.layout[{2, 1}] in edges
    assert image.layout[{1, 2}] in edges
    assert image.layout[{1, 0}] in edges
    assert image.layout[{1,1}] == 1427
  end

  test "monster_at_location?" do
    grid = [
      "..................#..",
      "#....##....##....###.",
      ".#..#..#..#..#..#...."
    ] |> Grid.from_strs()

    assert monster_at_location?(grid, {0, 0})
  end

  test "monster_at_location? offset" do
    grid = [
      "...........................",
      "........................#..",
      "......#....##....##....###.",
      ".......#..#..#..#..#..#...."
    ] |> Grid.from_strs()

    assert monster_at_location?(grid, {6, 1})
  end

  test "monster_at_location? obscured" do
    grid = [
      "...........................",
      ".........#......###..#..#..",
      "...#..#..#.##..#.##..#.###.",
      "...#####.###.#..#..#.##...."
    ] |> Grid.from_strs()

    assert monster_at_location?(grid, {6, 1})
  end

  test "detect_monsters sample" do
    grid = FileUtils.get_file_as_strings("test/day20/monsters.txt") |> Day20.Grid.from_strs

    assert detect_monsters(grid) |> Enum.count == 2
  end


  @tag slow: true
  test "Part 1" do
    input = File.read!("test/day20/input.txt")
    assert Day20.part_1(input) == 140656720229539
  end

  @tag slow: true
  test "Part 2" do
    input = File.read!("test/day20/input.txt")
    assert Day20.part_2(input) == 1885
  end
end
