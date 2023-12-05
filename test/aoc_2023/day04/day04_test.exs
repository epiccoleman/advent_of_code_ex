defmodule Aoc2023.Day04Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2023.Day04
  import Checkov

  data_test "score_card" do
    assert score_card(line) == expected

    where([
      [:line, :expected],
      ["Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53", 8],
      ["Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19", 2],
      ["Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1", 2],
      ["Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83", 1],
      ["Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36", 0],
      ["Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11", 0]
    ])
  end

  test "Part 1 small" do
    input = [
      "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
      "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
      "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
      "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
      "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
      "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    ]

    assert part_1(input) == 13
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2023/day04/input.txt")
    assert part_1(input) == 28538
  end

  test "Part 2 small" do
    input = [
      "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
      "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
      "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
      "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
      "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
      "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    ]

    assert part_2(input) == 30
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2023/day04/input.txt")
    assert part_2(input) == 9_425_061
  end
end
