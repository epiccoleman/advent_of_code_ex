defmodule Aoc2022.Day06Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2022.Day06

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2022/day06/input.txt") |> hd
   assert part_1(input) == 1582
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2022/day06/input.txt") |> hd
   assert part_2(input) == 3588
  end
end
