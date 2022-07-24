input = AocUtils.FileUtils.get_file_as_strings("./test/aoc_2015/day06/input.txt")
instructions = Aoc2015.Day06.process_input(input)

# Benchee.run(%{
#   "process_input" => fn -> Day06.process_input(input)  end,
# })

# Benchee.run(%{
#   "map" => fn -> Enum.map(1..1_000000, &(&1 * &1))  end,
#   "pmap" => fn -> Day06.Part1.pmap(1..1_000000, &(&1 * &1))  end,
# })

Benchee.run(%{
  "Part 1 - do_instruction" => fn ->
    Enum.reduce(instructions, %{}, &(Aoc2015.Day06.Part1.do_instruction(&2, &1)))
 end,
  "Part 1 - do_instruction_merge" => fn ->
    Enum.reduce(instructions, %{}, &(Aoc2015.Day06.Part1.do_instruction_merge(&2, &1)))
 end,
#   "Part 1 - do_instruction_merge_parallel" => fn ->
#     Enum.map(instructions, &(Day06.Part1.do_instruction_merge_parallel(%{}, &1)))
#  end,
})

Benchee.run(%{
  "Part 2 - do_instruction_2" => fn ->
    Enum.reduce(instructions, %{}, &(Aoc2015.Day06.Part2.do_instruction_2(&2, &1)))
 end,
  "Part 2 - do_instruction_2_merge" => fn ->
    Enum.reduce(instructions, %{}, &(Aoc2015.Day06.Part2.do_instruction_2_merge(&2, &1)))
 end
})
