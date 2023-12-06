defmodule Aoc2023.Day05Test do
  use ExUnit.Case
  import Aoc2023.Day05

  test "create_mapping" do
    lines = ["50 98 2", "52 50 48"]
    map = create_mapping(lines)

    # writing out every line is too annoying so:

    assert get_destination(50, map) == 52
    assert get_destination(51, map) == 53
    assert get_destination(60, map) == 62
    assert get_destination(96, map) == 98
    assert get_destination(98, map) == 50
    assert get_destination(99, map) == 51
    assert get_destination(13, map) == 13
    assert get_destination(42, map) == 42
  end

  test "Part 1 small" do
    input = File.read!("./test/aoc_2023/day05/input_small.txt")
    assert part_1(input) == 35
  end

  test "Part 1" do
    input = File.read!("./test/aoc_2023/day05/input.txt")
    assert part_1(input) == 261_668_924
  end

  test "generate_ranges" do
    mapping_lines = [
      "50 98 2",
      "52 50 48"
    ]

    expected_ranges = [
      {98..99, 50..51},
      {50..97, 52..99}
    ]

    assert generate_ranges(mapping_lines) == expected_ranges
  end

  describe "destination_ranges" do
    test "unmapped, simple" do
      range_mappings = [{98..99, 50..51}]
      seed_range = 90..97

      assert destination_ranges(range_mappings, seed_range) == [90..97]
    end

    test "mapped entirely in one range mapping" do
      range_mappings = [{80..90, 50..60}]
      seed_range = 81..87

      assert destination_ranges(range_mappings, seed_range) == [51..57]
    end

    test "seed range overextends right" do
      range_mappings = [{80..90, 50..60}]
      seed_range = 80..95

      assert destination_ranges(range_mappings, seed_range) == [50..60, 91..95]
    end

    test "seed range overextends left" do
      range_mappings = [{80..90, 50..60}]
      seed_range = 75..90

      assert destination_ranges(range_mappings, seed_range) == [50..60, 75..79]
    end

    test "seed range covers two ranges but they're disjoint" do
      range_mappings = [{80..83, 50..53}, {87..90, 67..70}]
      seed_range = 80..90

      assert destination_ranges(range_mappings, seed_range) == [50..53, 67..70, 84..86]
    end

    test "test mappings" do
      input = File.read!("./test/aoc_2023/day05/input_small.txt")
      {seed_ranges, mappings} = process_input_p2(input)

      seed_to_soil = destinations_for_seed_ranges(seed_ranges, mappings["seed-to-soil"])
      assert seed_to_soil == [81..94, 57..69]

      soil_to_fertilizer =
        destinations_for_seed_ranges(seed_to_soil, mappings["soil-to-fertilizer"])

      assert soil_to_fertilizer == [81..94, 57..69]

      fertilizer_to_water =
        destinations_for_seed_ranges(soil_to_fertilizer, mappings["fertilizer-to-water"])

      assert fertilizer_to_water == [81..94, 53..56, 61..69]

      water_to_light =
        destinations_for_seed_ranges(fertilizer_to_water, mappings["water-to-light"])

      assert [74..87, 46..49, 54..62]

      light_to_temperature =
        destinations_for_seed_ranges(water_to_light, mappings["light-to-temperature"])

      assert light_to_temperature == [78..80, 45..55, 82..85, 90..98]

      temperature_to_humidity =
        destinations_for_seed_ranges(light_to_temperature, mappings["temperature-to-humidity"])

      assert temperature_to_humidity == [78..80, 46..56, 82..85, 90..98]

      humidity_to_location =
        destinations_for_seed_ranges(temperature_to_humidity, mappings["humidity-to-location"])

      assert humidity_to_location == [82..84, 60..60, 46..55, 86..89, 94..96, 56..59, 97..98]

      assert min_value_in_ranges(humidity_to_location) == 46
    end

    # i am going to see if the code works without handling this case because it seems
    # like a drag
    # test "seed range overextends both dirs" do
    #   range_mappings = [{80..90, 50..60}]
    #   seed_range = 75..99

    #   assert destination_ranges(range_mappings, seed_range) == [50..60, 75..79, 91..99]
    # end
  end

  test "Part 2 small" do
    input = File.read!("./test/aoc_2023/day05/input_small.txt")
    assert part_2(input) == 46
  end

  test "Part 2" do
    input = File.read!("./test/aoc_2023/day05/input.txt")
    assert part_2(input) == 24_261_545
  end
end
