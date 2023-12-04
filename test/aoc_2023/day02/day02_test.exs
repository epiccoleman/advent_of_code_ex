defmodule Aoc2023.Day02Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Checkov
  import Aoc2023.Day02

  test "#process_pull" do
    pull_str = "1 red, 2 green, 6 blue"
    expected = %{blue: 6, green: 2, red: 1}

    assert process_pull(pull_str) == expected
  end

  test "#process_line" do
    line = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"

    expected = %{
      id: 1,
      pulls: [
        %{blue: 3, red: 4, green: 0},
        %{blue: 6, green: 2, red: 1},
        %{green: 2, blue: 0, red: 0}
      ]
    }

    assert process_line(line) == expected
  end

  test "#game_within_limit?" do
    game = %{
      id: 1,
      pulls: [
        %{blue: 3, red: 4, green: 0},
        %{blue: 6, green: 2, red: 1},
        %{green: 2, blue: 0, red: 0}
      ]
    }

    assert not game_within_limit?(game, 3, 4, 2)
    assert game_within_limit?(game, 6, 6, 6)
  end

  test "Part 1 small" do
    input = [
      "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
      "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
      "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
      "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    ]

    assert part_1(input) == 8
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2023/day02/input.txt")
    assert part_1(input) == 3035
  end

  data_test "minimal_cubes" do
    game = process_line(game_str)

    expected_minimum = %{
      red: min_red,
      green: min_green,
      blue: min_blue
    }

    assert minimal_cubes(game) === expected_minimum

    where([
      [:game_str, :min_red, :min_green, :min_blue],
      ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", 4, 2, 6],
      ["Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue", 1, 3, 4],
      ["Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red", 20, 13, 6],
      ["Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red", 14, 3, 15],
      ["Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green", 6, 3, 2]
    ])
  end

  data_test "game_power" do
    game = process_line(game_str)

    assert game_power(game) == expected_power

    where([
      [:game_str, :expected_power],
      ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", 48],
      ["Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue", 12],
      ["Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red", 1560],
      ["Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red", 630],
      ["Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green", 36]
    ])
  end

  test "Part 2 small" do
    input = [
      "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
      "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
      "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
      "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    ]

    assert part_2(input) == 2286
  end

  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2023/day02/input.txt")
    assert part_2(input) == 66027
  end
end
