defmodule Day02Test do
  use ExUnit.Case
  import Checkov

 data_test "#password_valid?" do
    assert Day02.password_valid?(entry) == result

    where [
      [:entry, :result],
      ["1-3 a: abcde", true],
      ["1-3 f: abcde", false],
      ["1-3 f: fffff", false]
    ]
  end

  data_test "#password_compliant_with_official_toboggan_corp_policy?" do
    assert Day02.password_compliant_with_official_toboggan_corp_policy?(entry) == result

    where [
      [:entry, :result],
      ["1-3 a: abcde", true],
      ["1-3 b: abcde", false],
      ["2-9 c: ccccccccc", false]
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day02/input.txt")
    assert Day02.part_1(input) == 536
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day02/input.txt")
    assert Day02.part_2(input) == 558
  end
end
