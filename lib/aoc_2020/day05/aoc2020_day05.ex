defmodule Day05 do
  def part_1(input) do
    input
    |> Enum.map(&convert_passport/1)
    |> Enum.max(fn x, y -> x.seat_id >= y.seat_id end)
    |> Map.get(:seat_id)
  end

  def part_2(input) do
    input
    |> Enum.map(&convert_passport/1)
    |> Enum.sort(fn a, b -> a.seat_id >= b.seat_id end)
    |> Enum.chunk_every(2, 1)
    |> Enum.find(fn [a, b] -> a.seat_id - b.seat_id > 1 end)
    # the rest of this is just to get the ID to come out of the test
    # answer was determined by looking at the above pipeline.
    |> hd
    |> Map.get(:seat_id)
    |> Kernel.-(1)
  end

  def convert_passport(passport_str) do
    { row_instructions, column_instructions } =
      passport_str
      |> String.graphemes()
      |> Enum.split(7)

    row = find_row(row_instructions)
    column = find_column(column_instructions)
    seat_id = (row * 8) + column

    %{ row: row,
       column: column,
       seat_id: seat_id }
  end

  def find_column(instructions) do
    find_column(instructions, Enum.to_list(0..7))
  end

  def find_column([current_instruction | instructions], nums) do
    {front_half, back_half} = halve_list(nums)

    case current_instruction do
      "L" -> find_column(instructions, front_half)
      "R" -> find_column(instructions, back_half)
    end
  end

  def find_column([], [value]) do
    value
  end

  def find_row(instructions) do
    find_row(instructions, Enum.to_list(0..128))
  end

  def find_row([current_instruction | instructions], nums) do
    {front_half, back_half} = halve_list(nums)

    case current_instruction do
      "F" -> find_row(instructions, front_half)
      "B" -> find_row(instructions, back_half)
    end
  end

  def find_row([], [value]) do
    value
  end

  def halve_list(list) do
    Enum.split(list, Integer.floor_div(length(list), 2))
  end
end
