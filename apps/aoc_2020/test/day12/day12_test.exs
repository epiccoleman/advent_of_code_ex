defmodule Day12Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils
  import Checkov


  import Day12
  alias Day12.BoatState

  data_test "manhattan_distance" do
    assert manhattan_distance(pos_a, pos_b) == result

    where [
      [:pos_a, :pos_b, :result],
      [{0, 0}, {17, -8}, 25]
    ]
  end

  data_test "process_instruction" do
    assert process_instruction(%BoatState{}, instruction) == result

    where [
      [:instruction, :result],
      ["F10", %BoatState{ position: {10, 0}, heading: "E" }],
      ["L90", %BoatState{ position: {0, 0}, heading: "N" }],
      ["L180", %BoatState{ position: {0, 0}, heading: "W" }],
      ["L270", %BoatState{ position: {0, 0}, heading: "S" }],
      ["R90", %BoatState{ position: {0, 0}, heading: "S" }],
      ["R180", %BoatState{ position: {0, 0}, heading: "W" }],
      ["R270", %BoatState{ position: {0, 0}, heading: "N" }],
      ["N10", %BoatState{ position: {0, 10}, heading: "E" }],
      ["S10", %BoatState{ position: {0, -10}, heading: "E" }],
      ["E10", %BoatState{ position: {10, 0}, heading: "E" }],
      ["W10", %BoatState{ position: {-10, 0}, heading: "E" }],
    ]
  end

 test "example part 1" do
    input = [ "F10", "N3", "F7", "R90", "F11" ]
    assert Day12.part_1(input) == 25
  end

  data_test "process_instruction_part_2" do
    assert process_instruction_part_2(%BoatState{}, instruction) == result

    where [
      [:instruction, :result],
      ["F10", %BoatState{ position: {100, 10}, heading: "E", waypoint: {10, 1} }],
      ["L90", %BoatState{ position: {0, 0}, heading: "E" , waypoint: {-1, 10}}],
      ["L180", %BoatState{ position: {0, 0}, heading: "E" , waypoint: {-10, -1}}],
      ["L270", %BoatState{ position: {0, 0}, heading: "E" , waypoint: {1, -10}}],
      ["R90", %BoatState{ position: {0, 0}, heading: "E" , waypoint: {1, -10}}],
      ["R180", %BoatState{ position: {0, 0}, heading: "E" , waypoint: {-10, -1}} ],
      ["R270", %BoatState{ position: {0, 0}, heading: "E" , waypoint: {-1, 10} }],
      ["N10", %BoatState{ position: {0, 0}, heading: "E", waypoint: {10, 11} }],
      ["S10", %BoatState{ position: {0, 0}, heading: "E", waypoint: {10, -9} }],
      ["E10", %BoatState{ position: {0, 0}, heading: "E", waypoint: {20, 1} }],
      ["W10", %BoatState{ position: {0, 0}, heading: "E", waypoint: {0, 1} }],
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day12/input.txt")
    assert Day12.part_1(input) == 882
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day12/input.txt")
    assert Day12.part_2(input) == 28885
  end
end
