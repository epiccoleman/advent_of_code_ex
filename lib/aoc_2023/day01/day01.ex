defmodule Aoc2023.Day01 do
  @nums %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "eno" => 1,
    "owt" => 2,
    "eerht" => 3,
    "ruof" => 4,
    "evif" => 5,
    "xis" => 6,
    "neves" => 7,
    "thgie" => 8,
    "enin" => 9
  }

  def first_digit(line) do
    Regex.run(~r/[0-9]{1}/, line) |> hd
  end

  def last_digit(line) do
    line
    |> String.reverse()
    |> first_digit()
  end

  def calibration_value(line) do
    first = first_digit(line)
    last = last_digit(line)

    String.to_integer(first <> last)
  end

  def part_1(input) do
    input
    |> Enum.map(&calibration_value/1)
    |> Enum.sum()
  end

  def convert_number(str) do
    case Integer.parse(str) do
      {x, _} -> x
      :error -> @nums[str]
    end
  end

  def first_p2(line) do
    Regex.run(~r/([0-9]|one|two|three|four|five|six|seven|eight|nine){1}/, line, capture: :first)
    |> hd()
    |> convert_number()
  end

  def last_p2(line) do
    line_rev = String.reverse(line)

    Regex.run(~r/([0-9]|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin){1}/, line_rev,
      capture: :first
    )
    |> hd()
    |> convert_number()
  end

  def calibration_p2(line) do
    first = first_p2(line)
    last = last_p2(line)

    first * 10 + last
  end

  def part_2(input) do
    input
    |> Enum.map(&calibration_p2/1)
    |> Enum.sum()
  end
end
