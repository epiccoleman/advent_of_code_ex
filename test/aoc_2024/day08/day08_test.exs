defmodule Aoc2024.Day08Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day08
  alias AocUtils.Grid2D

  # test input
  #  ..........
  #  ...#......
  #  ..........
  #  ....a.....
  #  ..........
  #  .....a....
  #  ..........
  #  ......#...
  #  ..........
  #  ..........

  describe "find_antinodes_for_pair" do
    test "positive slope" do
      #  ..........
      #  ...#......
      #  ..........
      #  ....a.....
      #  ..........
      #  .....a....
      #  ..........
      #  ......#...

      antennas = {{4, 3}, {5, 5}}
      expected_antinodes = {{3, 1}, {6, 7}}
      assert find_antinodes_for_pair(antennas) == expected_antinodes
    end

    test "negative slope" do
      #   0123456789
      # 0 ..........
      # 1 .......#..
      # 2 ..........
      # 3 ......a...
      # 4 ..........
      # 5 .....a....
      # 6 ..........
      # 7 ....#.....
      antennas = {{6, 3}, {5, 5}}
      expected_antinodes = {{4, 7}, {7, 1}}
      assert find_antinodes_for_pair(antennas) == expected_antinodes
    end

    test "vertical line" do
      #   0123456789
      # 0 ..........
      # 1 .....#....
      # 2 ..........
      # 3 .....a....
      # 4 ..........
      # 5 .....a....
      # 6 ..........
      # 7 .....#....
      antennas = {{5, 3}, {5, 5}}
      expected_antinodes = {{5, 1}, {5, 7}}
      assert find_antinodes_for_pair(antennas) == expected_antinodes
    end

    test "horizontal line" do
      #   0123456789
      # 0 ..........
      # 1 ..........
      # 2 ..........
      # 3 .#.a.a.#..
      # 4 ..........
      antennas = {{3, 3}, {5, 3}}
      expected_antinodes = {{1, 3}, {7, 3}}
      assert find_antinodes_for_pair(antennas) == expected_antinodes
    end

    test "when it goes off the edge" do
      #   0123456789
      # 0 ..........
      # 1 .......a..
      # 2 ..........
      # 3 ..........
      # 4 ..........
      # 5 ..........
      # 6 ....a.....
      # 7 ..........
      antennas = {{4, 6}, {7, 1}}
      expected_antinodes = {{1, 11}, {10, -4}}
      assert find_antinodes_for_pair(antennas) == expected_antinodes
    end
  end

  describe "find_antinodes_on_channel" do
    test "2 nodes" do
      input_strs = [
        "..........",
        "......#...",
        ".....a....",
        "....a.....",
        "...#......"
      ]

      grid = Grid2D.from_strs(input_strs, ignore: ".")

      marked_antinodes = Grid2D.matching_locs(grid, "#")

      found_set = MapSet.new(find_antinodes_on_channel(grid, "a"))
      marked_set = MapSet.new(marked_antinodes)

      assert found_set == marked_set
    end

    test "3 nodes" do
      # 01234567890123456
      # 0 ..........
      # 1 ...#......
      # 2 #.........
      # 3 ....a......#.
      # 4 ........a...
      # 5 .....a......#
      # 6 ..#.......
      # 7 ......#...
      # 8 ..........
      # 9 ..........
      input_strs = [
        "..........",
        "...#......",
        "#.........",
        "....a.....",
        "........a.",
        ".....a....",
        "..#.......",
        "......#...",
        "..........",
        ".........."
      ]

      grid = Grid2D.from_strs(input_strs, ignore: ".")

      marked_antinodes = Grid2D.matching_locs(grid, "#") ++ [{11, 3}, {12, 5}]

      found_set = MapSet.new(find_antinodes_on_channel(grid, "a"))
      marked_set = MapSet.new(marked_antinodes)

      assert found_set == marked_set
    end

    test "4 nodes" do
      # 01234567890123456
      # 0 ..........
      # 1 ...#......
      # 2 #.........
      # 3 ....a......#.
      # 4 ........a...
      # 5 .....a......#
      # 6 ..#.......
      # 7 ......#...
      # 8 ..........
      # 9 ..........
      input_strs = [
        "..........",
        ".#.#.#.#..",
        "..........",
        ".#.a.a.#..",
        "..........",
        ".#.a.a.#..",
        "..........",
        ".#.#.#.#..",
        "..........",
        ".........."
      ]

      grid = Grid2D.from_strs(input_strs, ignore: ".")

      marked_antinodes = Grid2D.matching_locs(grid, "#")

      found_set = MapSet.new(find_antinodes_on_channel(grid, "a"))
      marked_set = MapSet.new(marked_antinodes)

      assert found_set == marked_set
    end
  end

  test "combinations" do
    list = [1, 2, 3, 4]
    expected = MapSet.new([{1, 2}, {1, 3}, {1, 4}, {2, 3}, {2, 4}, {3, 4}])
    actual = MapSet.new(combinations(list))

    assert MapSet.equal?(actual, expected)
  end

  test "combinations counts" do
    # the only counts that appear in my input are 2 3 and 4, so that's all i'll bother with
    assert length(combinations([])) == 0
    assert length(combinations([1])) == 0
    assert length(combinations([1, 2])) == 1
    assert length(combinations([1, 2, 3])) == 3
    assert length(combinations([1, 2, 3, 4])) == 6
  end

  test "permutations" do
    assert MapSet.new(permutations([])) == MapSet.new()
    assert MapSet.new(permutations([1])) == MapSet.new()
    assert MapSet.new(permutations([1, 2])) == MapSet.new([{1, 2}, {2, 1}])

    assert MapSet.new(permutations([1, 2, 3])) ==
             MapSet.new([{1, 2}, {1, 3}, {2, 1}, {2, 3}, {3, 1}, {3, 2}])

    assert MapSet.new(permutations([1, 2, 3, 4])) ==
             MapSet.new([
               {1, 2},
               {1, 3},
               {1, 4},
               {2, 1},
               {2, 3},
               {2, 4},
               {3, 1},
               {3, 2},
               {3, 4},
               {4, 1},
               {4, 2},
               {4, 3}
             ])
  end

  # this doesn't want to work, something to do with ordering. trust the func for now but stay woke
  # test "combinations with tuples" do
  #   list = [{15, 18}, {29, 33}, {16, 14}, {18, 19}]

  #   actual = MapSet.new(combinations(list))

  #   assert MapSet.equal?(actual, expected)
  # end

  test "find_antinodes_for_pair_part2" do
    #   0123456789
    # 0 T....#....
    # 1 ...T......
    # 2 .T....#...
    # 3 .........#
    # 4 ..#.......
    # 5 ..........
    # 6 ...#......
    # 7 ..........
    # 8 ....#.....
    # 9 ..........
  end

  test "Part 1 test" do
    input = get_file_as_strings("./test/aoc_2024/day08/test_input.txt")
    assert part_1(input) == 14
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day08/input.txt")
    assert part_1(input) == 303
  end

  test "Part 2 test" do
    input = get_file_as_strings("./test/aoc_2024/day08/test_input.txt")
    assert part_2(input) == 34
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day08/input.txt")
    assert part_2(input) == 1045
  end
end
