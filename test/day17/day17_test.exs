defmodule Day17Test do
  use ExUnit.Case
  import Day17

  test "enumerate_cube_neighbors" do
    neighbors = enumerate_cube_neighbors({0, 0, 0})
    assert length(neighbors) == 26
  end

  test "part 1 small" do
    input = [".#.", "..#", "###"]
    assert part_1(input) == 112
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("test/day17/input.txt")
    assert Day17.part_1(input) == 317
  end

  test "part 2 small" do
    input = [".#.", "..#", "###"]
    assert part_2(input) == 848
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("test/day17/input.txt")
    assert Day17.part_2(input) == 1692
  end
end
