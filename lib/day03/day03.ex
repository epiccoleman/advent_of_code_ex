  defmodule Day03 do
    alias Day03.TreeMap

    def sled_path({slope_x, slope_y}, max_y) do
      Stream.iterate({0, 0}, fn {x, y} -> { x + slope_x , y + slope_y } end )
      |> Enum.take_while(fn { _x, y } -> y <= max_y end)
    end

    def count_hits(tree_map, slope) do
      sled_path(slope, tree_map.height)
      |> Enum.filter(fn position -> TreeMap.tree_at_position?(tree_map, position) end)
      |> Enum.count()
    end

    def part_1(input) do
      input
      |> TreeMap.tree_map_from_string_list()
      |> count_hits({3, 1})
    end

    def part_2(input) do
      tree_map = input |> TreeMap.tree_map_from_string_list()

      slopes_to_check = [ {1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2} ]

      slopes_to_check
      |> Enum.map(fn slope -> count_hits(tree_map, slope) end)
      |> Enum.reduce(&*/2)
    end
  end
