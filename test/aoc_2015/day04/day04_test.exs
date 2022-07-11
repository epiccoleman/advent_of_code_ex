defmodule Aoc2015.Day04Test do
  use ExUnit.Case
  alias Aoc2015.Day04

  @tag slow: true
  test "Part 1" do
   input = "bgvyzdsv"
   assert Day04.part_1(input) == 254575
  end

  @tag slow: true
  test "Part 2" do
   input = "bgvyzdsv"
   assert Day04.part_2(input) == 1038736
  end
end
