defmodule Day11 do
  def to_seat_map(input) do
    char_grid = input |> Enum.map(&String.graphemes/1)
    height = char_grid |> length()
    width = char_grid |> Enum.at(0) |> length()

    for y <- 0..(height - 1),
        x <- 0..(width - 1) do
      loc_val = char_grid |> Enum.at(y) |> Enum.at(x)
      {x, y, loc_val}
    end
    |> Enum.reduce(%{}, fn {x, y, val}, acc ->
      Map.put(acc, {x, y}, val)
    end)
  end

  def neighbors(seat_map, {x, y}) do
    for x <- [x - 1, x, x + 1],
        y <- [y - 1, y, y + 1] do
      {x, y}
    end
    |> Enum.reject(fn {x_0, y_0} -> x == x_0 and y == y_0 end)
    |> Enum.map(fn loc -> Map.get(seat_map, loc) end)
    # assuming we don't wrap or anything weird
    |> Enum.reject(&is_nil/1)
  end

  def count_occupied_neighbors(seat_map, loc) do
    neighbors(seat_map, loc)
    |> Enum.count(&(&1 == "#"))
  end

  def next_cell_state(seat_map, loc) do
    current = Map.get(seat_map, loc)
    occupied_neighbors = count_occupied_neighbors(seat_map, loc)

    cond do
      current == "#" and occupied_neighbors >= 4 -> "L"
      current == "#" and occupied_neighbors < 4 -> "#"
      current == "L" and occupied_neighbors == 0 -> "#"
      current == "L" and occupied_neighbors > 0 -> "L"
      current == "." -> "."
    end
  end

  def next_board_state(original_seat_map) do
    original_seat_map
    |> Map.keys()
    |> Enum.reduce(%{}, fn loc, new_map ->
      new_map
      |> Map.put(loc, next_cell_state(original_seat_map, loc))
    end)
  end

  def simulate_until_no_change(seat_map, seen_states \\ MapSet.new) do
    new_state = next_board_state(seat_map)

    if MapSet.member?(seen_states, new_state) do
      seat_map
    else
      simulate_until_no_change(new_state, MapSet.put(seen_states, new_state))
    end
  end

  ###
  def count_visible_seats(seat_map, loc) do
    directions =
      for x <- [-1, 0, 1],
          y <- [-1, 0, 1] do
            {x, y}
          end
      |> Enum.reject(&(&1 == {0, 0}))

    directions
    |> Enum.map(fn direction -> check_for_visible_seat_in_direction(seat_map, loc, direction) end)
    |> Enum.count(&(&1 == "#"))
  end

  def check_for_visible_seat_in_direction(seat_map, {loc_x, loc_y}, {slope_x, slope_y}) do
    Stream.iterate({loc_x + slope_x, loc_y + slope_y}, fn {x, y} -> { x + slope_x , y + slope_y } end )
    |> Enum.take_while(fn loc -> Map.has_key?(seat_map, loc) end)
    # |> IO.inspect()
    |> Enum.map(&(Map.get(seat_map, &1)))
    # |> IO.inspect()
    |> Enum.find(&(&1 == "#" or &1 == "L"))
  end

  def next_cell_state_2(seat_map, loc) do
    current = Map.get(seat_map, loc)
    occupied_neighbors = count_visible_seats(seat_map, loc)

    cond do
      current == "#" and occupied_neighbors >= 5 -> "L"
      current == "#" and occupied_neighbors < 5 -> "#"
      current == "L" and occupied_neighbors == 0 -> "#"
      current == "L" and occupied_neighbors > 0 -> "L"
      current == "." -> "."
    end
  end

  def next_board_state_2(original_seat_map) do
    original_seat_map
    |> Map.keys()
    |> Enum.reduce(%{}, fn loc, new_map ->
      new_map
      |> Map.put(loc, next_cell_state_2(original_seat_map, loc))
    end)
  end

  def simulate_until_no_change_2(seat_map, seen_states \\ MapSet.new) do
    new_state = next_board_state_2(seat_map)

    if MapSet.member?(seen_states, new_state) do
      seat_map
    else
      simulate_until_no_change_2(new_state, MapSet.put(seen_states, new_state))
    end
  end
  ###
  def part_1(input) do
    input
    |> to_seat_map()
    |> simulate_until_no_change()
    |> Enum.count(fn {_, val} -> val == "#" end)
  end

  def part_2(input) do
    input
    |> to_seat_map()
    |> simulate_until_no_change_2()
    |> Enum.count(fn {_, val} -> val == "#" end)
  end
end
