defmodule Aoc2015.Day03 do

  def map_houses(directions, state \\ %{position: {0, 0}, visited: %{}} )

  def map_houses([], state) do
    state
  end

  def map_houses([ direction | rest ], %{position: {x, y}, visited: visited}) do
    new_visited = Map.update(visited, {x,y}, 1, &(&1 + 1))
    new_pos = case direction do
      "<" -> { x - 1, y}
      ">" -> { x + 1, y}
      "^" -> { x, y + 1}
      "v" -> { x, y - 1}
    end

    map_houses(rest, %{position: new_pos, visited: new_visited})
  end

  def part_1(input) do
    input
    |> String.graphemes()
    |> map_houses()
    |> Map.get(:visited)
    |> Enum.count()
  end

  def part_2(input) do
    directions = input
    |> String.graphemes()

    santa_directions = directions |> Enum.take_every(2)

    robo_santa_directions =
      directions
      |> Enum.drop(1)
      |> Enum.take_every(2)

    santa_visited = map_houses(santa_directions)[:visited]
    robo_santa_visited = map_houses(robo_santa_directions)[:visited]

    all_houses = Map.merge(santa_visited, robo_santa_visited, fn _pos, s_gifts, rs_gifts ->
      s_gifts + rs_gifts
    end)

    Enum.count(all_houses)
  end
end
