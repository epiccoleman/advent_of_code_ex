alias AocUtils.Grid2D, as: Grid

# import Aoc2021.Grid2D.Transformations
small_complete_grid =
  Grid.from_strs([
    "#.##.",
    "##...",
    ".#.#.",
    "#.##.",
    "##...",
  ])

small_sparse_grid =
  Grid.new(x_max: 4, y_max: 4)
  |> Grid.update({0,0}, "#")
  |> Grid.update({1,1}, "#")
  |> Grid.update({2,2}, "#")
  |> Grid.update({3,4}, "#")
  |> Grid.update({4,3}, "#")

med_complete_grid = Grid.new(x_max: 100, y_max: 100, default: ".")
med_sparse_grid = Grid.new(x_max: 100, y_max: 100)
med_sparse_grid = Enum.reduce(1..100, med_sparse_grid, fn x, acc -> Grid.update(acc, {x, x}, "#") end)

large_complete_grid = Grid.new(x_max: 1000, y_max: 1000, default: ".")
large_sparse_grid = Grid.new(x_max: 1000, y_max: 1000)
large_sparse_grid = Enum.reduce(1..1000, large_sparse_grid, fn x, acc -> Grid.update(acc, {x, x}, "#") end)

inputs = %{
  "5x5 complete" => small_complete_grid,
  "5x5 sparse" => small_sparse_grid,
  "100x100 complete" => med_complete_grid,
  "100x100 sparse" => med_sparse_grid,
  "1000x1000 complete" => large_complete_grid,
  "1000x1000 sparse" => large_sparse_grid
}

Benchee.run(%{
  "rotate" => fn grid -> Grid.Transformations.rotate(grid) end,
  "rotate - old version" => fn grid -> Grid.Transformations.Old.rotate(grid) end,
},
inputs: inputs)

Benchee.run(%{
  "flip_horiz" => fn grid -> Grid.Transformations.flip_horiz(grid) end,
  "flip_horiz" => fn grid -> Grid.Transformations.Old.flip_horiz(grid) end,
},
inputs: inputs)

Benchee.run(%{
  "flip_vert" => fn grid -> Grid.Transformations.flip_vert(grid) end,
  "flip_vert - old version" => fn grid -> Grid.Transformations.Old.flip_vert(grid) end,
},
inputs: inputs)
