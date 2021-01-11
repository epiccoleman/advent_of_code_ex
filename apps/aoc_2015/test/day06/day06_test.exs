defmodule Day06Test do
  use ExUnit.Case
  import AOCUtils.FileUtils
  import Day06

  test "process_input" do
    input = [
      "turn on 489,959 through 759,964",
      "turn off 820,516 through 871,914",
      "toggle 427,423 through 929,502"]

    assert process_input(input) == [
      {:on, 489..759, 959..964},
      {:off, 820..871, 516..914},
      {:toggle, 427..929, 423..502},
    ]
  end

  test "do_instruction" do
    instruction = {:on, 1..3, 1..2}
    assert Day06.Part1.do_instruction(%{}, instruction) == %{
      {1,1} => :on,
      {2,1} => :on,
      {3,1} => :on,
      {1,2} => :on,
      {2,2} => :on,
      {3,2} => :on,
    }
  end

  test "do_instructions" do
    instructions = [
      {:on, 1..3, 1..2},
      {:off, 3..3, 1..2},
      {:toggle, 2..3, 2..2}
    ]

    assert Day06.Part1.do_instructions(instructions) == %{
      {1,1} => :on,
      {2,1} => :on,
      {3,1} => :off,
      {1,2} => :on,
      {2,2} => :off,
      {3,2} => :on
    }

  end

  @tag slow: true
  test "Part 1" do
   input = get_file_as_strings("test/day06/input.txt")
   assert part_1(input) == 569999
  end

  @tag slow: true
  test "Part 2" do
   input = get_file_as_strings("test/day06/input.txt")
   assert part_2(input) == 17836115
  end
end
