defmodule Day15Test do
  use ExUnit.Case
  import Checkov

  data_test "part 1 samples" do
    assert Day15.part_2(input, 2020).last_spoken == result

    where [
      [:input, :result],
      [[0, 3, 6], 436],
      [[1, 3, 2], 1],
      [[2, 1, 3], 10],
      [[1, 2, 3], 27],
      [[2, 3, 1], 78],
      [[3, 2, 1], 438],
      [[3, 1, 2], 1836],
    ]
  end

  test "Part 1" do
    input = [ 12, 20, 0, 6, 1, 17,  7]
    assert Day15.part_1(input).last_spoken == 866
  end

#  takes around 2 minutes to run, i'll take it
  # actually, got it down to like 20 seconds, I'll super take it
  # @tag timeout: 120000
  # test "Part 2" do
  #   input = [ 12, 20, 0, 6, 1, 17,  7]
  #   assert Day15.part_2(input, 30000000).last_spoken == 1437692
  # end
end
