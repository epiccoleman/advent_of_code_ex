input = AOCUtils.FileUtils.get_file_as_integers("./test/aoc_2021/day06/input.txt")

#the smart version is obviously faster but I'm curious how much so
Benchee.run(%{
  "naive lanternfish sim" => fn -> Aoc2021.Day06.simulate_lanternfish_reproduction(input, 100) end,
  "smart lanternfish sim" => fn -> Aoc2021.Day06.simulate_lanternfish_reproduction_smart(input, 100) end,
})

# Name                            ips        average  deviation         median         99th %
# smart lanternfish sim       15.70 K      0.00006 s   ±542.46%      0.00005 s      0.00015 s
# naive lanternfish sim     0.00088 K         1.14 s     ±7.74%         1.15 s         1.27 s
#
# Comparison:
# smart lanternfish sim       15.70 K
# naive lanternfish sim     0.00088 K - 17886.93x slower +1.14 s
