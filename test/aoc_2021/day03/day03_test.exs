defmodule Aoc2021.Day03Test do
  use ExUnit.Case
  import AOCUtils.FileUtils
  import Aoc2021.Day03

  @test_input [ "00100", "11110", "10110", "10111", "10101", "01111",
                "00111", "11100", "10000", "11001", "00010", "01010" ]

  test "calculate_gamma" do
    assert calculate_gamma(@test_input) == 22
  end

  test "calculate_epsilon" do
    assert calculate_epsilon(@test_input) == 9
  end

  test "calculate_power_consumption" do
    assert calculate_power_consumption(@test_input) == 198
  end

  test "calculate_oxygen_generator_rating" do
    assert calculate_oxygen_generator_rating(@test_input) == 23
  end

  test "calculate_co2_scrubber_rating" do
    assert calculate_co2_scrubber_rating(@test_input) == 10
  end

  test "calculate_life_support_rating" do
    assert calculate_life_support_rating(@test_input) == 230
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day03/input.txt")
   assert part_1(input) == 2648450
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day03/input.txt")
   assert part_2(input) == 2845944
  end
end
