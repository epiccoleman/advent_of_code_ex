Benchee.run(
  %{
    "brute force" => fn input -> Aoc2023.Day06.simulate_race(input) end,
    "math version" => fn input -> Aoc2023.Day06.solve_race(input) end
  },
  inputs: %{
    "small case from sample" => {7, 9},
    "bigger case from sample" => {30, 200},
    "bump it up more" => {30000, 500_000}
    # "part 2 input" => {35_696_887, 213_116_810_861_248},
    # "even bigger input" => {435_696_887, 2_213_116_810_861_248}
  }
)
