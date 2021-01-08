defmodule Day08Test do
  use ExUnit.Case
  alias AOCUtils.FileUtils

  test "part 2 - execution halts when ip goes past end of instructions" do
    input = ["nop +0", "acc +1", "jmp +4", "acc +3", "jmp -3", "acc -99", "acc +1",
    "nop -4", "acc +6"]
    state = %Day08.ExecutionState{instructions: input}

    {:halt, end_state} = Day08.execute({:continue, state})

    assert end_state.acc == 8
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day08/input.txt")
    assert Day08.part_1(input) == 1337
  end

  @tag slow: true
  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day08/input.txt")
    assert Day08.part_2(input) == 1358
  end
end
