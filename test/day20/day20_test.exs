defmodule Day20Test do
  use ExUnit.Case
  import Day20


  test "Part 1" do
    input = File.read!("test/day20/input.txt")
    assert Day20.part_1(input) == 140656720229539
  end

  # test "Part 2" do
  #   input = FileUtils.get_file_as_integers("test/day20/input.txt")
  #   assert Day20.part_2(input) == 0
  # end
end
