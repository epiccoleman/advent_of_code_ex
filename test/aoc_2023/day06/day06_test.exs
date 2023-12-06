defmodule Aoc2023.Day06Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2023.Day06

  test "Part 1 sample" do
    input = ["7 9", "15 40", "30 200"]
    assert part_1(input) == 288
  end

  test "Part 1" do
    # vimmed it for more better
    input = get_file_as_strings("./test/aoc_2023/day06/input.txt")
    assert part_1(input) == 170_000
  end

  @tag slow: true
  @tag timeout: 30000
  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2023/day06/input_original.txt")
    assert part_2(input) == 20_537_782
  end
end
