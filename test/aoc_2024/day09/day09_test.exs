defmodule Aoc2024.Day09Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day09

  test "parse_disk_map" do
    # disk map should look like this:

    # 0..111....22222
    # 012345678901234

    disk_map_str = "12345"

    # this is reversed because it seems to make more sense for the files to be ... reversed
    # i.e. in "right to left" order for the next step in the process.
    #
    # it's gonna be fine, trust me
    expected = {Enum.reverse([{0..0, 0}, {3..5, 1}, {10..14, 2}]), [1..2, 6..9]}

    assert parse_disk_map(disk_map_str) == expected
  end

  test "parse_disk_map bigger" do
    # disk map should look like this:

    # 00...111...2...333.44.5555.6666.777.888899
    # 012345678901234567890123456789012345678901

    disk_map_str = "2333133121414131402"

    expected =
      {Enum.reverse([
         {0..1, 0},
         {5..7, 1},
         {11..11, 2},
         {15..17, 3},
         {19..20, 4},
         {22..25, 5},
         {27..30, 6},
         {32..34, 7},
         {36..39, 8},
         {40..41, 9}
       ]), [2..4, 8..10, 12..14, 18..18, 21..21, 26..26, 31..31, 35..35]}

    assert parse_disk_map(disk_map_str) == expected
  end

  describe "refragment" do
    test "when there's just the right amount of space" do
      disk_map = parse_disk_map("12302")

      expected_disk_map = {Enum.reverse([{0..0, 0}, {3..5, 1}, {6..7, 2}]), [1..2]}
      assert expected_disk_map == disk_map

      # should be like this:
      # 0...111223
      # and go to:
      # 022111

      expected_refragmented = [{3..5, 1}, {0..0, 0}, {1..2, 2}]
      assert refragment(disk_map) == expected_refragmented
    end

    test "when there's more free space than file" do
      disk_map = parse_disk_map("1330201")

      # 0...111223

      expected_refragmented = MapSet.new([{0..0, 0}, {4..6, 1}, {2..3, 2}, {1..1, 3}])
      actual_refragmented = MapSet.new(refragment(disk_map))
      assert actual_refragmented == expected_refragmented
    end

    test "when file is too big for free space" do
      disk_map = parse_disk_map("13314")
      # 0...111.2222
      # 012345678901
      # should become
      # 02221112
      # 01234567

      # expected_files = MapSet.new([{0..0, 0}, {4..6, 1}, {8..11, 2}])
      # expected_free_space = MapSet.new([])


      expected_refragmented = MapSet.new([{0..0, 0}, {1..3, 2}, {4..6, 1}, {7..7, 2}])
      actual_refragmented = MapSet.new(refragment(disk_map))
      assert actual_refragmented == expected_refragmented
    end

    test "when there is more free space than will be filled by moving files" do
      # but that free space on the end is going to remain specified and that is a problem

      disk_map = parse_disk_map("14314")
      # 0....111.2222
      # should become
      # 02222111

      expected_refragmented = MapSet.new([{0..0, 0}, {1..4, 2}, {5..7, 1}])
      actual_refragmented = MapSet.new(refragment(disk_map))
      assert actual_refragmented == expected_refragmented

    end
  end

  test "defrag" do
    disk_map = parse_disk_map("2333133121414131402")
    defragged = defrag(disk_map)

    assert print_disk_map(defragged) == "00992111777.44.333....5555.6666.....8888.."
  end

  test "Part 1 test" do

    assert part_1("2333133121414131402") == 1928
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2024/day09/input.txt") |> hd()
   assert part_1(input) == 6341711060162
  end

  test "Part 2 test" do

    assert part_2("2333133121414131402") == 2858
  end


  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2024/day09/input.txt") |> hd()
   assert part_2(input) == 6377400869326
  end
end
