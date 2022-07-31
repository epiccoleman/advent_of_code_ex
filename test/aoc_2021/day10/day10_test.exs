defmodule Aoc2021.Day10Test do
  use ExUnit.Case
  import Checkov
  import AocUtils.FileUtils
  import Aoc2021.Day10


  # data_test "basin_size" do
  #   test_grid = input_to_grid(@test_input)
  #   assert basin_size(test_grid, low_point) == result

  #   where [
  #     [:low_point, :result],
  #     [{1,0}, 3],
  #     [{9,0}, 9],
  #     [{2,2}, 14],
  #     [{6,4}, 9],
  #   ]
  # end

  data_test "get_completion_str" do
    processed_line = process_line(line_str)
    assert result == get_completion_str(processed_line)

    where [
      [:line_str, :result],
      ["[({(<(())[]>[[{[]{<()<>>", "}}]])})]"],
      ["[(()[<>])]({[<{<<[]>>(", ")}>]})"],
      ["(((({<>}<{<{<>}{[]{[]{}", "}}>}>))))"],
      ["{<[[]]>}<{[{[{[]{()[[[]", "]]}}]}]}>"],
      ["<{([{{}}[<[[[<>{}]]]>[]]", "])}>"],
    ]
  end

  data_test "score_completion_str" do
    assert score == score_completion_str(completion_str)

    where [
      [:completion_str, :score],
      ["}}]])})]", 288957],
      [")}>]})", 5566],
      ["}}>}>))))", 1480781],
      ["]]}}]}]}>", 995444],
      ["])}>", 294],
    ]
  end


  test "Part 1" do
   input = get_file_as_strings("./test/aoc_2021/day10/input.txt")
   assert part_1(input) == 392367
  end

  test "Part 2" do
   input = get_file_as_strings("./test/aoc_2021/day10/input.txt")
   assert part_2(input) == 2192104158
  end
end
