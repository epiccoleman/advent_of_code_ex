defmodule Day03Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  alias Day03.TreeMap

  test "generate tree map" do
    input = [ "..#..", ".#..#" ]
    tree_map = TreeMap.tree_map_from_string_list(input)

    assert tree_map.height == 2
    assert tree_map.width == 5
    assert tree_map.trees == MapSet.new([{1, 1}, {2, 0}, {4, 1}])

  end

  test "tree_at_position? simple" do
    input = [ "..#..", ".#..#" ]
    tree_map = TreeMap.tree_map_from_string_list(input)

    assert not TreeMap.tree_at_position?(tree_map, {0, 0})
    assert TreeMap.tree_at_position?(tree_map, {1, 1})
  end

  test "tree_at_position? off edge" do
    input = [ "..#..", ".#..#" ]
    tree_map = TreeMap.tree_map_from_string_list(input)

    assert TreeMap.tree_at_position?(tree_map, {7, 0})
    assert TreeMap.tree_at_position?(tree_map, {9, 1})
    assert not TreeMap.tree_at_position?(tree_map, {13, 1})
    assert not TreeMap.tree_at_position?(tree_map, {10, 3})
  end

  test "sled_path" do
    input = [ "..#..", ".#..#", "....." ]
    tree_map = TreeMap.tree_map_from_string_list(input)

    assert Day03.sled_path({1,1}, tree_map.height ) == [{0, 0}, {1, 1}, {2, 2}, {3, 3}]
  end

  test "count_hits" do
    input = [ "..#..",
              ".#..#",
              "..#..",
              "...#." ]
    tree_map = TreeMap.tree_map_from_string_list(input)

    assert Day03.count_hits(tree_map, {1,1}) == 3
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day03/input.txt")
    assert Day03.part_1(input) == 145
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day03/input.txt")
    assert Day03.part_2(input) == 3424528800
  end
end
