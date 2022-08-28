defmodule Aoc2021.Day14Test do
  use ExUnit.Case
  import Aoc2021.Day14

  test "do_insertion" do
    input = File.read!("./test/aoc_2021/day14/sample_input.txt")
    {polymer, rules} = process_input(input)

    result = do_insertion(String.graphemes(polymer), rules)

    assert result == "NCNBCHB"
  end

  test "repeat_insertions" do
    input = File.read!("./test/aoc_2021/day14/sample_input.txt")

    assert repeat_insertions(input, 1) == "NCNBCHB"
    assert repeat_insertions(input, 2) == "NBCCNBBBCBHCB"
    assert repeat_insertions(input, 3) == "NBBBCNCCNBBNBNBBCHBHHBCHB"
  end

  test "count_elements_after_insertions 1" do
    input = File.read!("./test/aoc_2021/day14/sample_input.txt")
    {polymer_str, rules} = process_input(input)

    expected = %{
      "B" => 2,
      "C" => 2,
      "N" => 2,
      "H" => 1
    }
    assert count_elements_after_n_iterations(polymer_str, rules, 1) == expected
  end

  test "count_elements_after_insertions 2" do
    input = File.read!("./test/aoc_2021/day14/sample_input.txt")
    {polymer_str, rules} = process_input(input)

    #NBCCNBBBCBHCB
    expected = %{
      "B" => 6,
      "C" => 4,
      "H" => 1,
      "N" => 2,
    }
    assert count_elements_after_n_iterations(polymer_str, rules, 2) == expected
  end

  test "count_elements_after_insertions 3" do
    input = File.read!("./test/aoc_2021/day14/sample_input.txt")
    {polymer_str, rules} = process_input(input)

    expected = %{
      "B" => 11,
      "C" => 5,
      "H" => 4,
      "N" => 5,
    }
    assert count_elements_after_n_iterations(polymer_str, rules, 3) == expected
  end

  test "count_elements_after_insertions 10" do
    input = File.read!("./test/aoc_2021/day14/sample_input.txt")
    {polymer_str, rules} = process_input(input)

    expected = %{
      "B" => 1749,
      "C" => 298,
      "H" => 161,
      "N" => 865,
    }
    assert count_elements_after_n_iterations(polymer_str, rules, 10) == expected
  end

  test "Part 1" do
   input = File.read!("./test/aoc_2021/day14/input.txt")
   assert part_1(input) == 3284
  end

  @tag timeout: :infinity
  test "Part 2" do
   input = File.read!("./test/aoc_2021/day14/input.txt")
   assert part_2(input) == 4302675529689
  end
end
