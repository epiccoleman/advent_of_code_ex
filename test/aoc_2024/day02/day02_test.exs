defmodule Aoc2024.Day02Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day02
  import Checkov

  test "input_to_reports" do
    input = get_file_as_strings("./test/aoc_2024/day02/test_input.txt")

    reports = input_to_reports(input)

    expected_reports = [
      [7, 6, 4, 2, 1],
      [1, 2, 7, 8, 9],
      [9, 7, 6, 2, 1],
      [1, 3, 2, 4, 5],
      [8, 6, 4, 4, 1],
      [1, 3, 6, 7, 9]
    ]

    assert reports == expected_reports
  end

  data_test("report_safe?") do
    assert report_safe?(report) == result

    where([
      [:report, :result],
      [[7, 6, 4, 2, 1], true],
      [[1, 2, 7, 8, 9], false],
      [[9, 7, 6, 2, 1], false],
      [[1, 3, 2, 4, 5], false],
      [[8, 6, 4, 4, 1], false],
      [[1, 3, 6, 7, 9], true]
    ])
  end

  test("moisten_report") do
    report = [7, 6, 4, 2, 1]

    expected = [
      [6, 4, 2, 1],
      [7, 4, 2, 1],
      [7, 6, 2, 1],
      [7, 6, 4, 1],
      [7, 6, 4, 2]
    ]

    assert moisten_report(report) == expected
  end

  data_test("report_safe_with_dampening?") do
    assert report_safe_with_dampening?(report) == result

    where([
      [:report, :result],
      [[7, 6, 4, 2, 1], true],
      [[1, 2, 7, 8, 9], false],
      [[9, 7, 6, 2, 1], false],
      [[1, 3, 2, 4, 5], true],
      [[8, 6, 4, 4, 1], true],
      [[1, 3, 6, 7, 9], true]
    ])
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day02/input.txt")
    assert part_1(input) == 321
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day02/input.txt")
    assert part_2(input) == 386
  end
end
