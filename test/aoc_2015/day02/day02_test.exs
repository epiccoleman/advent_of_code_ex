defmodule Aoc2015.Day02Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  alias Aoc2015.Day02

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2015/day02/input.txt")
   assert Day02.part_1(input) == 1586300
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2015/day02/input.txt")
   assert Day02.part_2(input) == 3737498
  end
end
