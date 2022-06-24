defmodule Day06Test do
  use ExUnit.Case

  import Checkov

  data_test "process_group_1" do
    assert Day06.process_group_1(group) == result

    where [
      [:group, :result],
      ["abc", MapSet.new(["a", "b", "c"])],
      ["a\na\na", MapSet.new(["a"])],
      ["abc\ncde\nefg\nf", MapSet.new(["a", "b", "c", "d", "e", "f", "g"])],
    ]
  end

  data_test "process_group_2" do
    assert Day06.process_group_2(group) == result

    where [
      [:group, :result],
      ["abc", MapSet.new(["a", "b", "c"])],
      ["a\na\na", MapSet.new(["a"])],
      ["abc\ncde\nefgc\nfc", MapSet.new(["c"])],
    ]
  end

  test "Part 1" do
    input = File.read!("test/day06/input.txt") |> String.split("\n\n")
    assert Day06.part_1(input) == 6763
  end

  test "Part 2" do
    input = File.read!("test/day06/input.txt") |> String.split("\n\n")
    assert Day06.part_2(input) == 3512
  end
end
