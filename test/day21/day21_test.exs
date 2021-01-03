defmodule Day21Test do
  use ExUnit.Case
  import Day21

  test "Part 1" do
    input = FileUtils.get_file_as_strings("test/day21/input.txt")
    assert part_1(input) == 2170
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("test/day21/input.txt")
    assert part_2(input) == "nfnfk,nbgklf,clvr,fttbhdr,qjxxpr,hdsm,sjhds,xchzh,"
  end
end
