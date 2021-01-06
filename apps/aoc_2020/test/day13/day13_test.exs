defmodule Day13Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  import Checkov
  import Day13

  test "process_input_part_1" do
    input = [ "939", "7,13,x,x,59,x,31,19"]
    {earliest, timestamps } = process_input_part_1(input)

    assert earliest == 939
    assert timestamps |> Enum.sort == [7,13,19,31,59]
  end

  test "closest_departure_time" do
    assert closest_departure_time(59, 939) == 944
  end

  test "part 1 example" do
    input = [ "939", "7,13,x,x,59,x,31,19"]
    assert part_1(input) == 295
  end

  test "get_id_offset_pairs" do
    input = ["17","x","13","19"]

    assert get_id_offset_pairs(input) ==
      [ {17, 0}, {13, 2}, {19, 3} ]
  end

  test "test_timestamp" do
    offset_pairs = [ {17, 0}, {13, 2}, {19, 3} ]

    assert test_timestamp(offset_pairs, 3416) == false
    assert test_timestamp(offset_pairs, 3417) == true
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day13/input.txt")
    assert Day13.part_1(input) == 3246
  end

  data_test "part 2 examples" do
    assert part_2(input, 0) == result

    where [
      [:input, :result],
      ["17,x,13,19", 3417],
      ["67,7,59,61", 754018],
      ["67,x,7,59,61", 779210],
      ["67,7,x,59,61", 1261476],
      ["1789,37,47,1889", 1202161486],
    ]

  end

  data_test "part 2 examples with do thing" do
    assert part_2_smart(input) == result

    where [
      [:input, :result],
      ["17,x,13,19", 3417],
      ["67,7,59,61", 754018],
      ["67,x,7,59,61", 779210],
      ["67,7,x,59,61", 1261476],
      ["1789,37,47,1889", 1202161486],
    ]
  end

  # @tag timeout: 3600000
  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day13/input.txt") |> List.last
    assert Day13.part_2_smart(input) == 1010182346291467
  end
end
