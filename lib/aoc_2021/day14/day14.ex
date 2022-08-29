defmodule Aoc2021.Day14 do

  def process_input(input) do
    [polymer, rules_str] = String.split(input, "\n\n")

    rules =
      rules_str
      |> String.split("\n")
      |> Enum.map(fn rule_str ->
        rule_str
        |> String.split(" -> ")
        |> List.to_tuple()
      end)
      |> Map.new()

    {polymer, rules}
  end

  # def do_insertion(polymer, rules) do
  #   chunks =
  #     polymer
  #     |> String.graphemes()
  #     |> Enum.chunk_every(2, 1, :discard)
  #     |> Enum.map(&Enum.join/1)

  #   Enum.map(chunks, fn chonk ->
  #     # little clever - since Enum.join will automatically ignore a nil, we can just always check for the chonk
  #     [a, b] = String.graphemes(chonk)
  #     mid = Map.get(rules, chonk)

  #     Enum.join([a, mid, b])
  #   end)
  #   |> Enum.join()
  # end

  def do_insertion(polymer, rules, acc \\ "")
  def do_insertion([last_char], _rules, acc) do
    acc <> last_char
  end

  def do_insertion([first_char | rest ] = _polymer, rules, acc) do
    second_char = hd(rest)
    current_chunk = Enum.join([first_char, second_char])

    middle_char = Map.get(rules, current_chunk)

    new_acc =
      if not is_nil(middle_char) do
        acc <> first_char <> middle_char
      else
        acc <> first_char
      end

    do_insertion(rest, rules, new_acc)
  end

  def repeat_insertions(input, count) do
    {polymer, rules} = process_input(input)

    Enum.reduce(1..count, polymer, fn _i, acc ->
      acc
      |> String.graphemes()
      |> do_insertion(rules)
    end)
  end

  @doc """
  Takes in a polymer string and converts it to a map of pairs and their counts.
  """
  def polymer_to_pairs(polymer) do
    polymer_chars = String.graphemes(polymer)

    polymer_chars
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a <> b end)
    |> AocUtils.MiscUtils.count_list_elements()
  end

  def perform_pair_insertions(polymer_map, rules) do
    polymer_map
    |> Enum.reduce(%{}, fn {pair_str, current_count}, acc ->
      if Map.has_key?(rules, pair_str) and current_count > 0 do
        middle = Map.get(rules, pair_str)
        [a, b] = String.graphemes(pair_str)
        new_pair_str_1 = a <> middle
        new_pair_str_2 = middle <> b

        acc
        |> Map.update(new_pair_str_1, current_count, fn old_count -> old_count + current_count end)
        |> Map.update(new_pair_str_2, current_count, fn old_count -> old_count + current_count end)
      else
        acc
      end
    end)
  end

  def count_elements(polymer_map, last_char) do
    polymer_map
    |> Enum.reduce(%{}, fn {pair, pair_count}, acc ->
      [char, _] = String.graphemes(pair)

      Map.update(acc, char, pair_count, fn current_count -> pair_count + current_count end)
    end)
    |> Map.update(last_char, 1, fn current_count -> current_count + 1 end)
  end

  def iterate_pair_insertions(polymer_map, rules, count \\ 1) do
    Enum.reduce(1..count, polymer_map, fn _i, acc ->
      perform_pair_insertions(acc, rules)
    end)
  end

  def count_elements_after_n_iterations(polymer_str, rules, i_count \\ 1) do
    polymer_map = polymer_to_pairs(polymer_str)
    last_char = List.last(String.graphemes(polymer_str))

    polymer_map
    |> iterate_pair_insertions(rules, i_count)
    |> count_elements(last_char)
  end

  def part_1(input, n \\ 10) do
    polymer_string = repeat_insertions(input, n)

    counts =
      polymer_string
      |> String.graphemes()
      |> AocUtils.MiscUtils.count_list_elements()

    {_c, most_common_count} = Enum.max_by(counts, fn {_char, count} -> count end)
    {_c, least_common_count} = Enum.min_by(counts, fn {_char, count} -> count end)

    most_common_count - least_common_count
  end

  def part_2(input, n \\ 40) do
    {polymer_str, rules} = process_input(input)
    counts = count_elements_after_n_iterations(polymer_str, rules, n)

    {_c, most_common_count} = Enum.max_by(counts, fn {_char, count} -> count end)
    {_c, least_common_count} = Enum.min_by(counts, fn {_char, count} -> count end)

    most_common_count - least_common_count
  end
end
