defmodule Aoc2020.Day04Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  import Checkov

  data_test "valid_passport?" do
    assert Day04.valid_passport?(input) == result

    where [
      [:input, :result],
      ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm", true],
      ["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 hgt:183cm", true],
      ["iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929", false]
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("./test/aoc_2020/day04/input.txt")
    assert Day04.part_1(input) == 226
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("./test/aoc_2020/day04/input.txt")
    assert Day04.part_2(input) == 160
  end
end
