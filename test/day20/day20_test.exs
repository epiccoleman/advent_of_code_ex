defmodule Day20Test do
  use ExUnit.Case
  import Day20

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
    edges = neighbor_map |> Enum.filter(fn {id, l} -> length(l) == 3 end)  |> Enum.map(fn {id, _} -> id end)

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


  test "Part 1" do
    input = File.read!("test/day20/input.txt")
    assert Day20.part_1(input) == 140656720229539
  end

  # test "Part 2" do
  #   input = FileUtils.get_file_as_integers("test/day20/input.txt")
  #   assert Day20.part_2(input) == 0
  # end
end
