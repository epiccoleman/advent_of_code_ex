defmodule Day03.TreeMap do
  defstruct trees: %MapSet{}, height: 0, width: 0

  def tree_map_from_string_list(map_strings) do
    char_grid = map_strings |> Enum.map(&String.graphemes/1)
    height = char_grid |> length()
    width = char_grid |> Enum.at(0) |> length()

    trees =
      for y <- 0..height-1,
          x <- 0..width-1 do
        if ((char_grid |> Enum.at(y) |> Enum.at(x)) == "#" ) do
          {x, y}
        end
      end
    |> Enum.reject(&is_nil/1)

    tree_set = MapSet.new(trees)

    %Day03.TreeMap{
      height: height,
      width: width,
      trees: tree_set
    }
  end

  def tree_at_position?(tree_map, {x, y}) do
    position = { rem(x, tree_map.width), y}
    Enum.member?(tree_map.trees, position)
  end
end
