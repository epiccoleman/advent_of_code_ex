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

  def first_p1(line) do
    get_first_matching_num(line, ~r/[0-9]{1}/)
  end

  def last_p1(line) do
    line
    |> String.reverse()
    |> first_p1()
  end

  def calibration_p1(line) do
    calibration(line, &first_p1/1, &last_p1/1)
  end

  def part_1(input) do
    part(input, &calibration_p1/1)
  end

  def first_p2(line) do
    get_first_matching_num(line, ~r/([0-9]|one|two|three|four|five|six|seven|eight|nine){1}/)
  end

  def last_p2(line) do
    String.reverse(line)
    |> get_first_matching_num(~r/([0-9]|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin){1}/)
  end

  def calibration_p2(line) do
    calibration(line, &first_p2/1, &last_p2/1)
  end

  def part_2(input) do
    part(input, &calibration_p2/1)
  end

  def convert_number(str) do
    case Integer.parse(str) do
      {x, _} -> x
      :error -> @nums[str]
    end
  end

  defp get_first_matching_num(line, regex) do
    Regex.run(regex, line, capture: :first)
    |> hd()
    |> convert_number()
  end

  defp calibration(line, first_digit_fn, last_digit_fn) do
    first = first_digit_fn.(line)
    last = last_digit_fn.(line)

    first * 10 + last
  end

  defp part(input, calibration_fn) do
    input
    |> Enum.map(calibration_fn)
    |> Enum.sum()
  end
end
