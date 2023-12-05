defmodule Aoc2023.Day05 do
  @doc """
  Given a set of lines, and a set of possible inputs, generates a
  map. The map's keys are the "sources", and the values at each key represent
  the mapping of that source to a destination.

  Rather than list every source number and its corresponding destination number
  one by one, the maps describe entire ranges of numbers that can be converted.
  Each line within a map contains three numbers: the destination range start,
  the source range start, and the range length.

  Any source numbers that aren't mapped correspond to the same destination number.
  We're going to handle this requirement via a special function for accessing
  the mappings, "get_mapping".
  """
  def create_mapping(lines) do
    lines
    |> Enum.map(&process_mapping_line/1)
  end

  @doc """
  Given a line of input, creates the corresponding map of source to destinations,
  as described by the puzzle text.
  """
  def process_mapping_line(line) do
    [destination_start, source_start, range_length] =
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    mapping_fn = fn source ->
      offset = abs(source_start - source)
      destination_start + offset
    end

    {source_start..(source_start + range_length - 1), mapping_fn}
  end

  def get_destination(source, map) do
    found_value =
      Enum.find_value(map, fn {range, funk} ->
        if(source in range, do: funk.(source))
      end)

    if(found_value, do: found_value, else: source)
  end

  def process_input(input_str) do
    sections = String.split(input_str, "\n\n")

    {seeds_str, mapping_strs} = List.pop_at(sections, 0)

    seeds =
      Regex.scan(~r/\d+/, seeds_str)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    mapping_strs
    |> Enum.map(fn str ->
      [mapping_name_str | mapping_lines] = String.split(str, "\n")

      [mapping_name, _junk] = String.split(mapping_name_str, " ")
      {mapping_name, create_mapping(mapping_lines)}
    end)
    |> Enum.into(%{})
    |> Map.put(:seeds, seeds)
  end

  def seeds_to_locations(seeds, puzzle_data) do
    seeds
    |> Enum.map(fn seed ->
      seed
      |> get_destination(puzzle_data["seed-to-soil"])
      |> get_destination(puzzle_data["soil-to-fertilizer"])
      |> get_destination(puzzle_data["fertilizer-to-water"])
      |> get_destination(puzzle_data["water-to-light"])
      |> get_destination(puzzle_data["light-to-temperature"])
      |> get_destination(puzzle_data["temperature-to-humidity"])
      |> get_destination(puzzle_data["humidity-to-location"])
    end)
  end

  def part_1(input) do
    puzzle_data = process_input(input)

    seeds_to_locations(puzzle_data.seeds, puzzle_data)
    |> Enum.min()
  end

  def part_2(input) do
    input
  end
end
