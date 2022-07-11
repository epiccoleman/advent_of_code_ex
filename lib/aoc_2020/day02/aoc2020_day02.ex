  defmodule Aoc2020.Day02 do
    def password_valid?(entry) do
      [ rule_str, password ] = entry |> String.split(": ")
      [ range_str, target_char ] = rule_str |> String.split(" ")
      [ range_start, range_end ] = range_str |> String.split("-") |> Enum.map(&String.to_integer/1)
      range = range_start..range_end

      char_count = Enum.count(String.graphemes(password), & &1 == target_char)

      char_count in range
    end

    def password_compliant_with_official_toboggan_corp_policy?(entry) do
      [ rule_str, password ] = entry |> String.split(": ")
      [ pos_str, target_char ] = rule_str |> String.split(" ")
      [ pos_1, pos_2 ] =
        pos_str
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(& &1 - 1) # decrement these numbers since the elves index starting at 1

      password_graphemes = password |> String.graphemes()
      pos_1_hit = Enum.at(password_graphemes, pos_1) == target_char
      pos_2_hit = Enum.at(password_graphemes, pos_2) == target_char

      (pos_1_hit and !pos_2_hit) or (pos_2_hit and !pos_1_hit) #xor
    end
    def part_1(input) do
      input
      |> Enum.count(&password_valid?/1)
    end

    def part_2(input) do
      input
      |> Enum.count(&password_compliant_with_official_toboggan_corp_policy?/1)
    end
  end
