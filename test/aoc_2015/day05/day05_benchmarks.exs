input = AocUtils.FileUtils.get_file_as_strings("./test/aoc_2015/day05/input.txt")

#contains_three_vowels
Benchee.run(%{
  "contains_three_vowels?" => fn -> Enum.map(input, &Aoc2015.Day05.contains_three_vowels?/1) end,
  "contains_three_vowels_regex?" => fn -> Enum.map(input, &Aoc2015.Day05.contains_three_vowels_regex?/1) end
})

#contains_doubled_letter
Benchee.run(%{
  "contains_a_doubled_letter?" => fn -> Enum.map(input, &Aoc2015.Day05.contains_a_doubled_letter?/1) end,
  "contains_a_doubled_letter_regex?" => fn -> Enum.map(input, &Aoc2015.Day05.contains_a_doubled_letter_regex?/1) end
})
