defmodule Aoc2021.Day03Test do
  use ExUnit.Case
  import AOCUtils.FileUtils
  import Aoc2021.Day03

  test "calculate_gamma" do
    test_input = [ "00100", "11110", "10110", "10111", "10101", "01111",
                    "00111", "11100", "10000", "11001", "00010", "01010" ]

    assert calculate_gamma(test_input) == 22
  end

  test "calculate_epsilon" do
    test_input = [ "00100", "11110", "10110", "10111", "10101", "01111",
                    "00111", "11100", "10000", "11001", "00010", "01010" ]

    assert calculate_epsilon(test_input) == 9
  end

  test "calculate" do
    test_input = [ "00100", "11110", "10110", "10111", "10101", "01111",
                    "00111", "11100", "10000", "11001", "00010", "01010" ]

    assert part_1(test_input) == 198
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day03/input.txt")
   assert part_1(input) == 2648450
  end

  #test "Part 2" do
  #  input = get_file_as_strings("./test/aoc_2021/day03/input.txt")
  #  assert part_2(input) == 0
  #end
end
