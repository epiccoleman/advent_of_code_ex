defmodule Aoc2020.Day19Test do
  use ExUnit.Case
  alias AocUtils.FileUtils

  import Day19

# 0: 4 1 5
# 1: 2 3 | 3 2
# 2: 4 4 | 5 5
# 3: 4 5 | 5 4
# 4: "a"
# 5: "b"

# ababbb
# bababa
# abbbab
# aaabbb
# aaaabbb

  test "Part 1" do
    input = FileUtils.get_file_as_strings("./test/aoc_2020/day19/input.txt")
    assert part_1(input) == 176
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("./test/aoc_2020/day19/input.txt")
    assert part_2(input) == 352
  end
end
