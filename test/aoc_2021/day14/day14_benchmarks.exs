input = File.read!("./test/aoc_2021/day14/input.txt")

Benchee.run(%{
  "string version" => fn iterations -> Aoc2021.Day14.part_1(input, iterations) end,
  "map version" => fn iterations -> Aoc2021.Day14.part_2(input, iterations) end,
},
inputs: %{
  "2 iterations" => 2,
  "5 iterations" => 5,
  "10 iterations" => 10,
  "12 iterations" => 12,
  "15 iterations" => 15,
  "20 iterations" => 20,
}
)
