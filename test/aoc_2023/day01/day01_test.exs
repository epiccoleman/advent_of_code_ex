defmodule Aoc2023.Day01Test do
  use ExUnit.Case
  import Checkov
  import AocUtils.FileUtils
  import Aoc2023.Day01

  data_test "first_p1" do
    assert first_p1(data) == result

    where([
      [:data, :result],
      ["1abc3", 1],
      ["123abc5", 1],
      ["w00t", 0]
    ])
  end

  data_test "last_p1" do
    assert last_p1(data) == result

    where([
      [:data, :result],
      ["1abc3", 3],
      ["123abc5", 5],
      ["w00t", 0],
      ["w00t13", 3]
    ])
  end

  data_test "calibration_p1" do
    assert calibration_p1(line) == result

    where([
      [:line, :result],
      ["1abc2", 12],
      ["pqr3stu8vwx", 38],
      ["a1b2c3d4e5f", 15],
      ["treb7uchet", 77]
    ])
  end

  test "Part 1 small" do
    input = ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
    assert part_1(input) == 142
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2023/day01/input.txt")
    assert part_1(input) == 55447
  end

  data_test "convert_number" do
    assert convert_number(data) == result

    where([
      [:data, :result],
      ["1", 1],
      ["one", 1],
      ["2", 2],
      ["4", 4],
      ["nine", 9]
    ])
  end

  data_test "first_p2" do
    assert first_p2(line) == result

    where([
      [:line, :result],
      ["two1nine", 2],
      ["eightwothree", 8],
      ["abcone2threexyz", 1],
      ["xtwone3four", 2],
      ["4nineeightseven2", 4],
      ["zoneight234", 1],
      ["7pqrstsixteen", 7]
    ])
  end

  data_test "last_p2" do
    assert last_p2(line) == result

    where([
      [:line, :result],
      ["two1nine", 9],
      ["eightwothree", 3],
      ["abcone2threexyz", 3],
      ["xtwone3four", 4],
      ["4nineeightseven2", 2],
      ["zoneight234", 4],
      ["7pqrstsixteen", 6]
    ])
  end

  data_test "calibration_p2" do
    assert calibration_p2(line) == result

    where([
      [:line, :result],
      ["two1nine", 29],
      ["eightwothree", 83],
      ["abcone2threexyz", 13],
      ["xtwone3four", 24],
      ["4nineeightseven2", 42],
      ["zoneight234", 14],
      ["7pqrstsixteen", 76],
      ["qszds3", 33],
      ["45gzmzzxh", 45]
    ])
  end

  test "part_2_small" do
    input = [
      "two1nine",
      "eightwothree",
      "abcone2threexyz",
      "xtwone3four",
      "4nineeightseven2",
      "zoneight234",
      "7pqrstsixteen"
    ]

    assert part_2(input) == 281
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2023/day01/input.txt")
    assert part_2(input) == 54706
  end
end
