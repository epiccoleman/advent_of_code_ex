defmodule Day16Test do
  use ExUnit.Case
  import Day16

  test "process_input_data" do
    input = File.read!("test/day16/small-input.txt")

    assert process_input_data(input) == %{

      constraints: %{
        "class" => [1..3, 5..7],
        "row" => [6..11, 33..44],
        "seat" => [13..40, 45..50]
      },

      my_ticket: [7, 1, 14],
      nearby_tickets: [
        [7,3,47],
        [40,4,50],
        [55,2,20],
        [38,6,12]
      ]
    }
  end

  test "discard_bad_tickets" do
    input = File.read!("test/day16/small-input.txt")

    assert process_input_data(input) |> discard_bad_tickets == %{

      constraints: %{
        "class" => [1..3, 5..7],
        "row" => [6..11, 33..44],
        "seat" => [13..40, 45..50]
      },

      my_ticket: [7, 1, 14],
      nearby_tickets: [
        [7,3,47]
      ]
    }
  end

  test "Part 1" do
    input = File.read!("test/day16/input.txt")
    assert Day16.part_1(input) == 26941
  end

  test "Part 2" do
    input = File.read!("test/day16/input.txt")
    assert Day16.part_2(input) == 634796407951
  end
end
