defmodule Day15 do
  def part_1(input, end_turn \\ 2020) do
    start_turn = length(input) + 1
    start_seen =
      input
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {n, turn}, seen -> Map.put(seen, n, [turn]) end)

    start_last_spoken = List.last(input)
    start_state = %{seen_nums: start_seen, last_spoken: start_last_spoken}

    Enum.reduce(start_turn..end_turn, start_state,
    fn turn_number, %{seen_nums: seen, last_spoken: last} ->
      # last number spoken will always exist in seen

      number_to_speak = if length(Map.get(seen, last)) == 1 do
        # then that was the first time last was spoken, so speak 0
        0
      else
        # then that wasn't the first time last was spoken, so speak seen[last][0] - seen[last][1]
        turns_where_last_was_spoken = Map.get(seen, last)
        most_recent_turn = turns_where_last_was_spoken |> Enum.at(0)
        second_most_recent_turn = turns_where_last_was_spoken |> Enum.at(1)

        most_recent_turn - second_most_recent_turn
      end

      new_seen_nums =
        seen
        |> Map.update(number_to_speak, [turn_number], fn turns_spoken -> [turn_number] ++ turns_spoken end)

      %{seen_nums: new_seen_nums, last_spoken: number_to_speak}
    end)
  end

  def part_2(input, end_turn) do
    start_turn = length(input) + 1
    # seen_nums = Enum.reduce(0..end_turn, %{}, &(Map.put(&2, &1, 0)))

    start_seen =
      input
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {n, turn}, seen -> Map.put(seen, n, turn) end)

    start_last_spoken = List.last(input)
    start_state = %{seen_nums: start_seen, last_spoken: start_last_spoken}

    Enum.reduce(start_turn..end_turn, start_state,
      fn turn_number, %{seen_nums: seen, last_spoken: last} ->

      number_to_speak = if Map.get(seen, last) == nil do
        0
      else
        most_recent_turn = turn_number - 1
        second_most_recent_turn = Map.get(seen, last)

        most_recent_turn - second_most_recent_turn
      end

      new_seen_nums = seen |> Map.put(last, turn_number - 1)
      %{seen_nums: new_seen_nums, last_spoken: number_to_speak}
    end)
  end

  # This ended up being way slower than the map version, but keeping it for posterity
  def part_2_list(input, end_turn) do
    start_turn = length(input) + 1
    seen_nums = List.duplicate(0, end_turn)

    start_seen =
      input
      |> Enum.with_index(1)
      |> Enum.reduce(seen_nums, fn {n, turn}, seen -> List.replace_at(seen, n, turn) end)

    start_last_spoken = List.last(input)
    start_state = %{seen_nums: start_seen, last_spoken: start_last_spoken}


    Enum.reduce(start_turn..end_turn, start_state,
      fn turn_number, %{seen_nums: seen, last_spoken: last} ->

      new_seen_nums = seen |> List.replace_at(last, turn_number - 1)

      number_to_speak = if Enum.at(seen, last) == 0 do
        0
      else
        most_recent_turn = turn_number - 1
        second_most_recent_turn = Enum.at(seen, last)

        most_recent_turn - second_most_recent_turn
      end

      %{seen_nums: new_seen_nums, last_spoken: number_to_speak}
    end)
  end
end
