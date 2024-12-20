defmodule Aoc2022.Day01Test do
  use ExUnit.Case
  import Aoc2022.Day01

  test "part 1 sample" do
    input = """
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
      """ |> String.trim()

    assert part_1(input) == 24000
  end

  test "Part 1" do
   input = File.read!("./test/aoc_2022/day01/input.txt")
   assert part_1(input) == 72511
  end

  test "Part 2" do
   input = File.read!("./test/aoc_2022/day01/input.txt")
   assert part_2(input) == 212117
  end
end
