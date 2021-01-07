defmodule Day02Test do
  use ExUnit.Case
  import AOCUtils.FileUtils
  import Day02

  test "Part 1" do
   input = get_file_as_strings("test/day02/input.txt")
   assert part_1(input) == 1586300
  end

  test "Part 2" do
   input = get_file_as_strings("test/day02/input.txt")
   assert part_2(input) == 3737498
  end
end
