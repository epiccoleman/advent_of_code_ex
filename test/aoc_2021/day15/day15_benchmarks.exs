input =
  AocUtils.FileUtils.get_file_as_strings("./test/aoc_2021/day15/input.txt")
  |> Aoc2021.Day15.input_to_grid()

Benchee.run(%{
  "v1 - naive" =>
    fn -> Aoc2021.Day15.Old.dijkstra_1(input, {0,0}, {99, 99}) end,
  "v2 - MapSet.member? instead of in" =>
    fn -> Aoc2021.Day15.Old.dijkstra_2(input, {0,0}, {99, 99}) end,
  "v3 - use new_distances instead of distances" =>
    fn -> Aoc2021.Day15.Old.dijkstra_3(input, {0,0}, {99, 99}) end,
  "v4 - only iterate distances once at end" =>
    fn -> Aoc2021.Day15.Old.dijkstra_3(input, {0,0}, {99, 99}) end,
  "v5 - search for next_current in unvisited instead of distances" =>
    fn -> Aoc2021.Day15.dijkstra(input, {0,0}, {99, 99}) end,
})
