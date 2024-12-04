defmodule Aoc2024.Day03Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day03

  test "Part 1 example" do
    input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    assert part_1(input) == 161
  end

  test "Part 1" do
    input = File.read!("./test/aoc_2024/day03/input.txt")
    assert part_1(input) == 174_960_292
  end

  test "Part 2 example" do
    input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert part_2(input) == 48
  end

  test "Part 2" do
    input = File.read!("./test/aoc_2024/day03/input.txt")
    assert part_2(input) == 56_275_602
  end
end
