defmodule Aoc2023.Day05Test do
  use ExUnit.Case
  import Aoc2023.Day05

  test "process_mapping_line" do
    line = "50 98 2"

    expected = %{
      98 => 50,
      99 => 51
    }

    assert process_mapping_line(line) == expected
  end

  test "create_mapping" do
    lines = ["50 98 2", "52 50 48"]
    map = create_mapping(lines)

    # writing out every line is too annoying so:

    assert get_destination(50, map) == 52
    assert get_destination(51, map) == 53
    assert get_destination(60, map) == 62
    assert get_destination(96, map) == 98
    assert get_destination(98, map) == 50
    assert get_destination(99, map) == 51
    assert get_destination(13, map) == 13
    assert get_destination(42, map) == 42
  end

  test "Part 1 small" do
    input = File.read!("./test/aoc_2023/day05/input_small.txt")
    assert part_1(input) == 35
  end

  # @tag timeout: :infinity
  # test "Part 1" do
  #   input = File.read!("./test/aoc_2023/day05/input.txt")
  #   assert part_1(input) == 0
  # end

  # test "Part 2" do
  #  input = File.read!("./test/aoc_2023/day05/input.txt")
  #  assert part_2(input) == 0
  # end
end
