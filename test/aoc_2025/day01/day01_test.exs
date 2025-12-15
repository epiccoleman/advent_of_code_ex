defmodule Aoc2025.Day01Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2025.Day01
  import Checkov

  data_test "rotate" do
    assert rotate(50, entry) == result

    where [
      [:entry, :result],
      ["L10", 40],
      ["R10", 60],
      ["R50", 0],
      ["R55", 5],
      ["L50", 0],
      ["L55", 95],
    ]
  end

  data_test "rotate examples" do
    assert rotate(start, entry) == result

    where [
      [:start, :entry, :result],
      [50, "L68", 82],
      [82, "L30", 52],
      [52, "R48", 0],
      [0, "L5", 95],
      [95, "R60", 55],
      [55, "L55", 0],
      [0, "L1", 99],
      [99, "L99", 0],
      [0, "R14", 14],
      [14, "L82", 32]
    ]
  end

  test "part 1 small" do
    input = [
        "L68",
        "L30",
        "R48",
        "L5",
        "R60",
        "L55",
        "L1",
        "L99",
        "R14",
        "L82"
    ]

    assert part_1(input) == 3
  end

  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2025/day01/input.txt")
   assert part_1(input) == 1100
  end

  data_test "rotate_with_click_count examples" do
    assert rotate_with_click_count(start, entry) == result



# In this example, the dial points at 0 three times at the end of a rotation, plus three more times during a rotation.
# So, in this example, the new password would be 6.

    where [
      [:start, :entry, :result],
# The dial starts by pointing at 50.
# The dial is rotated L68 to point at 82; during this rotation, it points at 0 once.
      [50, "L68", { 82, 1 }],
# The dial is rotated L30 to point at 52.
      [82, "L30", { 52, 0 }],
# The dial is rotated R48 to point at 0.
      [52, "R48", { 0, 1 }],
# The dial is rotated L5 to point at 95.
      [0, "L5", { 95, 0 }],
# The dial is rotated R60 to point at 55; during this rotation, it points at 0 once.
      [95, "R60", { 55, 1 }],
# The dial is rotated L55 to point at 0.
      [55, "L55", { 0, 1 }],
# The dial is rotated L1 to point at 99.
      [0, "L1", { 99, 0 }],
# The dial is rotated L99 to point at 0.
      [99, "L99", { 0, 1 }],
# The dial is rotated R14 to point at 14.
      [0, "R14", { 14, 0 }],
# The dial is rotated L82 to point at 32; during this rotation, it points at 0 once.
      [14, "L82", { 32, 1}],
      [50, "R1000", { 50, 10}]
      # [48, "L48", { 0, 1}],
    ]
  end

  test "Part 2 example" do
      input = [
      "L68",
      "L30",
      "R48",
      "L5",
      "R60",
      "L55",
      "L1",
      "L99",
      "R14",
      "L82"
    ]
    assert part_2(input) == 6
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2025/day01/input.txt")
   assert part_2(input) == 6358
  end
end
