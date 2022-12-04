defmodule Aoc2022.Day03 do

  def char_to_number(char) do
    # Check if the character is lowercase
    <<char_value::utf8>> = char
    if char_value in 97..122 do
      # Return a number from 1 to 26
      char_value - 96
    else
      # Return a number from 27 to 52
      char_value - 38
    end
  end

  def find_common_char(string) do
    # Split the string into two equal parts

    length = String.length(string)
    first_range = 0..trunc(length / 2) - 1
    second_range = trunc(length/2)..length

    string1 = String.slice(string, first_range) |> String.graphemes()
    string2 = String.slice(string, second_range) |> String.graphemes()

    _common_char =
      string1 |> Enum.find(fn c -> c in string2 end)
  end

  def part_1(input) do
    input
    |> Enum.map(&find_common_char/1)
    |> Enum.map(&char_to_number/1)
    |> Enum.sum
  end

  def part_2(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.map(fn group_of_3_bags ->
      [first | rest ] = group_of_3_bags
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&MapSet.new/1)

      Enum.reduce(rest, first, fn c, acc -> MapSet.intersection(acc, c) end)
      |> Enum.into([])
      |> hd()
    end)
    |> Enum.map(&char_to_number/1)
    |> Enum.sum

  end
end
