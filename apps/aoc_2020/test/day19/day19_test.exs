defmodule Day19Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

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
  # test do
  #   rules = %{
  #     0 => [1, 2],
  #     1 => "a",
  #     2 => [[1, 3], [3, 1]],
  #     3 => "b"
  #   }


  #   assert match_rule?(input_str, rule, rules)
  # end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("test/day19/input.txt")
    assert part_1(input) == 176
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("test/day19/input.txt")
    assert part_2(input) == 352
  end
end
