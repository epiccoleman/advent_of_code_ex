defmodule Aoc2023.Day05 do
  @doc """
  Given a set of lines, and a set of possible inputs, generates a
  map. The map's keys are the "sources", and the values at each key represent
  the mapping of that source to a destination.
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

  @doc """
  Given a source value and a set of source->dest mappings, converts the source value to the correct
  destination. If the source value is not present in any of the source ranges in the mapping, returns
  the unmodified source value.
  """
  def get_destination(source, map) do
    found_value =
      Enum.find_value(map, fn {range, funk} ->
        if(source in range, do: funk.(source))
      end)

    if(found_value, do: found_value, else: source)
  end

  @doc """
  Processes input for 2023-5 part 1
  """
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

  def part_1(input) do
    puzzle_data = process_input(input)

    puzzle_data.seeds
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
    |> Enum.min()
  end

  @doc """
  Given a set of lines, returns a list of tuples. The first value in the tuple
  is a source range, and the second value is a destination range.
  """
  def generate_ranges(mapping_lines) do
    mapping_lines
    |> Enum.map(fn line ->
      [destination_start, source_start, range_length] =
        line
        |> String.split()
        |> Enum.map(&String.to_integer/1)

      {source_start..(source_start + range_length - 1),
       destination_start..(destination_start + range_length - 1)}
    end)
  end

  @doc """
  Processes input for 2023-5 part 2
  """
  def process_input_p2(input_str) do
    sections = String.split(input_str, "\n\n")

    {seeds_str, mapping_strs} = List.pop_at(sections, 0)

    seeds =
      Regex.scan(~r/\d+/, seeds_str)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> a..(a + b - 1) end)

    range_mappings =
      mapping_strs
      |> Enum.map(fn str ->
        [mapping_name_str | mapping_lines] = String.split(str, "\n")

        [mapping_name, _junk] = String.split(mapping_name_str, " ")
        {mapping_name, generate_ranges(mapping_lines)}
      end)
      |> Enum.into(%{})

    {seed_ranges, range_mappings}
  end

  @doc """
  Given a single seed range, and a set of range mappings, returns a list
  of destination ranges for the seed range.
  """
  def destination_ranges(range_mappings, _seed_start.._seed_end//_ = seed_range) do
    initial_state = {[seed_range], []}
    destination_ranges(range_mappings, initial_state)
  end

  def destination_ranges(_range_mappings, {[], destinations}) do
    # base case - no seed ranges left to process
    destinations
  end

  def destination_ranges(range_mappings, {[seed_range | seed_rest], destinations}) do
    a..b//_ = seed_range

    mapping_containing_a = Enum.find(range_mappings, fn {s_r, _} -> a in s_r end)
    mapping_containing_b = Enum.find(range_mappings, fn {s_r, _} -> b in s_r end)

    {new_seeds, new_destinations} =
      cond do
        mapping_containing_a == nil and mapping_containing_b == nil ->
          # if neither a nor b are inside any of the source ranges in range_mappings,
          # then a..b is unmapped, and maps to itself.
          {[], [a..b]}

        mapping_containing_a == mapping_containing_b ->
          # if both a and b are in the same source range, they're covered by a single
          # mapping, and we return the sub-range of the destination_range from that mapping.
          # but we need to know how far into the destination range our seed range starts, so we
          # calculate an offset.
          {source_a.._source_b//_, dest_a.._dest_b//_} = mapping_containing_a
          offset = a - source_a
          dest_range = (dest_a + offset)..(dest_a + offset + Range.size(seed_range) - 1)
          {[], [dest_range]}

        mapping_containing_a != nil and mapping_containing_b == nil ->
          # if b is not mapped in any of the source ranges, but a is, then we know that a..n is mapped.
          # where n will be the highest number in the source range
          # then a..n is mapped, and we can generate the range and add it to new_destinations.
          # n+1..b gets added to new_seeds to be checked in the next round

          {source_a..source_b//_, dest_a..dest_b//_} = mapping_containing_a
          offset = a - source_a
          mapped_portion = (dest_a + offset)..dest_b
          unmapped_portion = (source_b + 1)..b
          {[unmapped_portion], [mapped_portion]}

        mapping_containing_a == nil and mapping_containing_b != nil ->
          # same logic as above, basically, but flipped
          {source_a.._source_b//_, dest_a.._dest_b//_} = mapping_containing_b
          offset = b - source_a
          mapped_portion = dest_a..(dest_a + offset)
          unmapped_portion = a..(source_a - 1)
          {[unmapped_portion], [mapped_portion]}

        # we know neither mapping is nil at this point.
        mapping_containing_a != mapping_containing_b ->
          # this is the case where both a and b appear in mapped ranges, but they are not the same
          # range. in this case the logic is similar to the above two cases, but we'll have 3 partitions
          # of the seed range - [a..n] and [m..b], which are mapped to destinations, and [n+1..m-1],
          # which we're not sure about yet, so it goes back into the lists of ranges to test.

          # also, i'm not even sure if this can happen.
          {a_source_a..a_source_b//_, a_dest_a..a_dest_b//_} = mapping_containing_a
          {b_source_a.._b_source_b//_, b_dest_a.._b_dest_b//_} = mapping_containing_b

          a_offset = a - a_source_a
          a_mapped_portion = (a_dest_a + a_offset)..a_dest_b

          b_offset = b - b_source_a
          b_mapped_portion = b_dest_a..(b_dest_a + b_offset)

          # there is not necessarily an unmapped portion - if a > b then
          # it produced a junk range. this is a bit of a hack, not sure if it will
          # stand up to real input. (it does stand up to the real input)
          # unmapped_a..unmapped_b = (a_source_b + 1)..(b_source_a - 1)
          unmapped_a..unmapped_b//_ = Range.new((a_source_b + 1),(b_source_a - 1), -1)

          unmapped_portion =
            if unmapped_a < unmapped_b do
              [unmapped_a..unmapped_b]
            else
              []
            end

          {unmapped_portion, [a_mapped_portion, b_mapped_portion]}
      end

    destination_ranges(
      range_mappings,
      {seed_rest ++ new_seeds, destinations ++ new_destinations}
    )
  end

  def destinations_for_seed_ranges(seed_ranges, range_mappings) do
    seed_ranges
    |> Enum.map(fn seed_range -> destination_ranges(range_mappings, seed_range) end)
    |> List.flatten()
  end

  @doc """
  Finds the lowest number possible in the given set of ranges.
  Assumes that the ranges are all increasing, i.e. that a <= b.
  """
  def min_value_in_ranges(ranges) do
    ranges
    |> Enum.map(fn a.._b//_ -> a end)
    |> Enum.min()
  end

  def part_2(input) do
    {seed_ranges, mappings} = process_input_p2(input)

    seed_ranges
    |> destinations_for_seed_ranges(mappings["seed-to-soil"])
    |> destinations_for_seed_ranges(mappings["soil-to-fertilizer"])
    |> destinations_for_seed_ranges(mappings["fertilizer-to-water"])
    |> destinations_for_seed_ranges(mappings["water-to-light"])
    |> destinations_for_seed_ranges(mappings["light-to-temperature"])
    |> destinations_for_seed_ranges(mappings["temperature-to-humidity"])
    |> destinations_for_seed_ranges(mappings["humidity-to-location"])
    |> min_value_in_ranges()
  end
end
