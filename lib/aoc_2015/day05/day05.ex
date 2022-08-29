defmodule Aoc2015.Day05 do
  def is_nice?(string) do # IS NICE
    contains_three_vowels?(string) and
    contains_a_doubled_letter_regex?(string) and
    not contains_banned_strings?(string)
  end

  # Comparison:
  # contains_three_vowels?              274.70
  # contains_three_vowels_regex?        150.43 - 1.83x slower +3.01 ms
  def contains_three_vowels?(string) do
    vowel_count =
      string
      |> String.graphemes()
      |> Enum.count(fn c -> c in [ "a", "e", "i", "o", "u"] end)


    vowel_count >= 3
  end

  def contains_three_vowels_regex?(string) do
    Regex.scan(~r/[aeiou]/, string) |> Enum.count
  end

  # Comparison:
  # contains_a_doubled_letter_regex?        408.50
  # contains_a_doubled_letter?              187.00 - 2.18x slower +2.90 ms
  def contains_a_doubled_letter_regex?(string) do
    Regex.match?(~r/([a-z])\1+/, string)
  end

  def contains_a_doubled_letter?(string) do
    string
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a, b] -> a == b end)
  end

  def contains_banned_strings?(string) do
    Regex.match?(~r/ab|cd|pq|xy/, string)
  end


  def is_very_nice?(string) do
    has_recurring_pair?(string)
    and contains_letter_sandwich?(string)
  end

  def has_recurring_pair?(string) do
    string
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(%{}, fn [{a, _i_0}, {b, _i_1}], acc ->
      Map.update(acc, a<>b, 1, &(&1 + 1))
    end)
    |> Enum.filter(fn {_, count} -> count > 1 end)
    |> Enum.into(%{})
    |> Map.keys
    |> Enum.map(fn candidate ->
      Regex.scan(~r/#{candidate}/, string, return: :index)
      |> Enum.chunk_every(2,1,:discard)
      |> Enum.any?(fn [[{i_0, _}], [{i_1, _}]] -> i_1 > i_0 + 1 end)
    end)
    |> Enum.any?()
  end

  def contains_letter_sandwich?(string) do
    Regex.match?( ~r{([a-z])[a-z]\1}, string )
  end

  def part_1(input) do
    input
    |> Enum.filter(&is_nice?/1)
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> Enum.filter(&is_very_nice?/1)
    |> Enum.count()
  end
end
