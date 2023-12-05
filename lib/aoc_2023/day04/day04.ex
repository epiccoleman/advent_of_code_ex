defmodule Aoc2023.Day04 do
  def setify(str_list) do
    str_list
    |> String.split()
    |> MapSet.new()
  end

  def calculate_score(winning_nums) do
    if(winning_nums == 0, do: 0, else: 2 ** (winning_nums - 1))
  end

  def score_card(line) do
    line
    |> count_matching_nums()
    |> calculate_score()
  end

  def count_matching_nums(line) do
    [_, num_str] = String.split(line, ": ")
    [win_nums, revealed_nums] = String.split(num_str, " | ")

    MapSet.intersection(
      setify(win_nums),
      setify(revealed_nums)
    )
    |> MapSet.size()
  end

  def parse_card(line) do
    [card_str, _] = String.split(line, ": ")
    [_, id_str] = String.split(card_str)
    matches = count_matching_nums(line)

    {String.to_integer(id_str), matches}
  end

  def part_1(input) do
    input
    |> Enum.map(&score_card/1)
    |> Enum.sum()
  end

  # eric wastl only wants one thing and its disgusting
  def part_2(input) do
    parsed =
      input
      |> Enum.map(&parse_card/1)
      |> Enum.map(fn {id, matched} -> {id, {matched, 1}} end)
      |> Enum.into(%{})

    Enum.reduce(1..map_size(parsed), parsed, fn i, state ->
      {matched, copies} = Map.get(state, i)

      if matched == 0 do
        state
      else
        range_to_update = (i + 1)..(i + matched)

        updates =
          Enum.reduce(range_to_update, %{}, fn j, acc ->
            {matched_to_update, copies_to_update} = Map.get(state, j)
            Map.put(acc, j, {matched_to_update, copies_to_update + copies})
          end)

        Map.merge(state, updates)
      end
    end)
    |> Enum.map(fn {_, {_, copies}} -> copies end)
    |> Enum.sum()
  end
end
