defmodule Day24 do
  def chunk_directions(direction_str, directions \\ [])
  def chunk_directions("", directions), do: directions

  def chunk_directions(direction_str, directions) do
    case String.graphemes(direction_str) do
      [c1, c2 | direction_rest] ->
        [direction, direction_rest] =
          cond do
            c1 == "e" or c1 == "w" ->
              [c1, [c2 | direction_rest]]

            # put c2 back onto str and direction is e or w
            c1 == "s" or c1 == "n" ->
              [c1 <> c2, direction_rest]
          end

        chunk_directions(Enum.join(direction_rest), directions ++ [direction])

      [c | direction_rest ] ->
        chunk_directions(Enum.join(direction_rest), directions ++ [c])
      end
  end

  def follow_direction(directions) do
    Enum.reduce(directions, {0, 0, 0}, fn direction, {x, y, z} ->
      case direction do
        "e" -> {x + 1, y - 1, z}
        "w" -> {x - 1, y + 1, z}
        "se" -> {x, y - 1 , z + 1}
        "nw" -> {x, y + 1 , z - 1}
        "ne" -> {x + 1, y , z - 1}
        "sw" -> {x - 1, y , z + 1}
      end
    end)
  end

  def apply_directions(directions) do
    directions
    |> Enum.reduce(%{}, fn direction, state ->
      location = follow_direction(direction)

      state
      |> Map.update(location, "black", fn color ->
        case color do
          "black" -> "white"
          "white" -> "black"
        end
      end)
    end)
  end

  def count_neighbors({x, y, z}, tile_map) do
    neighbor_positions = [
      {x + 1, y - 1, z},
      {x - 1, y + 1, z},
      {x, y - 1 , z + 1},
      {x, y + 1 , z - 1},
      {x + 1, y , z - 1},
      {x - 1, y , z + 1}
    ]

    neighbor_positions
    |> Enum.map(fn pos -> Map.get(tile_map, pos, "white") end)
    |> Enum.reduce(%{"white" => 0, "black" => 0}, fn color, acc -> Map.update!(acc, color, &(&1 + 1)) end)
  end

  def next_tile_state(pos, tile_map) do
    current_state = Map.get(tile_map, pos, "white")
    %{"black" => black_count, "white" => _white_count } = count_neighbors(pos, tile_map)

    cond do
      (current_state == "black") and (black_count == 0 or black_count > 2) -> "white"
      (current_state == "white") and (black_count == 2) -> "black"
      true -> current_state
    end
  end

  def update_tiles_brute_force(tile_map) do
    # bad runtime but i like this monstrosity of pattern matching too much to delete it
    # fuckin filthy lol, thanks elixir
    {{{ x_min, _, _ }, _},{{x_max, _, _}, _}} = Enum.min_max_by(tile_map, fn {{x, _, _}, _} -> x end)
    {{{ y_min, _, _ }, _},{{y_max, _, _}, _}} = Enum.min_max_by(tile_map, fn {{y, _, _}, _} -> y end)
    {{{ z_min, _, _ }, _},{{z_max, _, _}, _}} = Enum.min_max_by(tile_map, fn {{z, _, _}, _} -> z end)

    for x <- (x_min - 2)..(x_max + 2),
        y <- (y_min - 2)..(y_max + 2),
        z <- (z_min - 2)..(z_max + 2) do
          {{x, y, z}, next_tile_state({x, y, z}, tile_map)}
    end
    |> Enum.into(%{})
  end

  def update_tiles(tile_map) do
    # get next tile state for all black tiles and their neighbors
    black_tiles_and_their_neighbors =
      tile_map
      |> Enum.filter(fn {_pos, state} -> state == "black" end)
      |> Enum.map(fn {pos, _state} -> pos end)
      |> Enum.flat_map(fn {x, y, z} ->
       [{x, y, z},
        {x + 1, y - 1, z},
        {x - 1, y + 1, z},
        {x, y - 1 , z + 1},
        {x, y + 1 , z - 1},
        {x + 1, y , z - 1},
        {x - 1, y , z + 1}] end)

    black_tiles_and_their_neighbors
    |> Enum.map(fn pos -> {pos, next_tile_state(pos, tile_map)} end)
    |> Enum.into(%{})
  end

  def do_updates(tile_map, count \\ 1)  do
    Enum.reduce(1..count, tile_map, fn _i, acc ->
      update_tiles(acc)
    end)
  end

  def input_to_tile_map(input) do
    input
    |> Enum.map(&(chunk_directions/1))
    |> apply_directions()
  end


  def part_1(input) do
    input
    |> input_to_tile_map()
    |> Enum.count(fn {_pos, state} -> state == "black" end)
  end

  def part_2(input) do
    input
    |> input_to_tile_map()
    |> do_updates(100)
    |> Enum.count(fn {_, state} -> state == "black" end)
  end
end
