# 3390830
defmodule WarmupTest do
  use ExUnit.Case
  import Checkov

  data_test "#calculate_fuel_requirement" do
    assert Warmup.calculate_fuel_requirement(mass) == result

    where [
      [:mass, :result],
      [12, 2],
      [14, 2],
      [1969, 654],
      [100756, 33583]
    ]
  end

  data_test "#calculate_tyrannical" do
    assert Warmup.calculate_tyrannical(mass) == result

    where [
      [:mass, :result],
      [14, 2],
      [1969, 966],
      [100756, 50346]
    ]
  end

  test "Part 1" do
    input = FileUtils.get_file_as_integers("test/warmup/input.txt")
    assert Warmup.part_1(input) == 3390830
  end

  test "Part 2" do
    input = FileUtils.get_file_as_integers("test/warmup/input.txt")
    assert Warmup.part_2(input) == 5083370
  end
end
