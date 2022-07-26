input = AocUtils.FileUtils.get_file_as_integers("./test/aoc_2021/day06/input.txt")

#the smart version is obviously faster but I'm curious how much so
Benchee.run(%{
  "naive lanternfish sim" => fn iterations -> Aoc2021.Day06.simulate_lanternfish_reproduction(input, iterations) end,
  "smart lanternfish sim" => fn iterations -> Aoc2021.Day06.simulate_lanternfish_reproduction_smart(input, iterations) end,
},
inputs: %{
  "10 iterations" => 10,
  "20 iterations" => 20,
  "40 iterations" => 40,
  "80 iterations" => 80,
  "100 iterations" => 100,
  "120 iterations" => 120
}
)

# Benchee.run(%{
#   "smart lanternfish sim 1" => fn -> Aoc2021.Day06.simulate_lanternfish_reproduction_smart(input, 256) end,
#   "smart lanternfish sim 2" => fn -> Aoc2021.Day06.simulate_lanternfish_reproduction_smart(input, 1000) end,
#   "smart lanternfish sim 3" => fn -> Aoc2021.Day06.simulate_lanternfish_reproduction_smart(input, 10000) end,
# })

##### With input 10 iterations #####
# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       59.93 K       16.68 μs    ±68.70%          14 μs          47 μs
# naive lanternfish sim        7.23 K      138.25 μs    ±20.52%         131 μs         279 μs
#
# Comparison:
# smart lanternfish sim       59.93 K
# naive lanternfish sim        7.23 K - 8.29x slower +121.56 μs
#
# ##### With input 20 iterations #####
# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       54.91 K       18.21 μs    ±55.36%          16 μs          48 μs
# naive lanternfish sim        1.85 K      539.48 μs    ±18.93%         504 μs      928.43 μs
#
# Comparison:
# smart lanternfish sim       54.91 K
# naive lanternfish sim        1.85 K - 29.63x slower +521.27 μs
#
# ##### With input 40 iterations #####
# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       47.49 K      0.0211 ms    ±34.57%      0.0190 ms      0.0500 ms
# naive lanternfish sim        0.23 K        4.33 ms     ±8.97%        4.24 ms        5.58 ms
#
# Comparison:
# smart lanternfish sim       47.49 K
# naive lanternfish sim        0.23 K - 205.73x slower +4.31 ms
#
# ##### With input 80 iterations #####
# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       36.35 K      0.0275 ms    ±25.67%      0.0250 ms      0.0530 ms
# naive lanternfish sim     0.00540 K      185.08 ms    ±13.37%      182.74 ms      252.60 ms
#
# Comparison:
# smart lanternfish sim       36.35 K
# naive lanternfish sim     0.00540 K - 6727.19x slower +185.05 ms
#
# ##### With input 100 iterations #####
# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       33.36 K      0.00003 s    ±25.82%      0.00003 s      0.00006 s
# naive lanternfish sim     0.00090 K         1.12 s     ±8.70%         1.11 s         1.24 s
#
# Comparison:
# smart lanternfish sim       33.36 K
# naive lanternfish sim     0.00090 K - 37232.63x slower +1.12 s
#
# ##### With input 120 iterations #####
# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       29.87 K      0.00003 s    ±23.48%      0.00003 s      0.00006 s
# naive lanternfish sim     0.00014 K         7.13 s     ±0.00%         7.13 s         7.13 s
#
# Comparison:
# smart lanternfish sim       29.87 K
# naive lanternfish sim     0.00014 K - 212944.83x slower +7.13 s
