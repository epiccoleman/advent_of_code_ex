defmodule Day07Test do
  use ExUnit.Case

  test "process line" do
    g = Graph.new()
    test_str = "light red bags contain 1 bright white bag, 2 muted yellow bags."

    g = Day07.process_line(g, test_str)

    assert g |> Graph.vertices |> Enum.sort == [ "bright white", "light red", "muted yellow" ]
    assert g |> Graph.edges == [
      %Graph.Edge{label: nil, v1: "light red", v2: "bright white", weight: 1},
      %Graph.Edge{label: nil, v1: "light red", v2: "muted yellow", weight: 2}
    ]
  end

  test "process line with no other bags" do
    g = Graph.new()
    test_str = "faded chartreuse bags contain no other bags."

    g = Day07.process_line(g, test_str)

    assert g |> Graph.vertices |> Enum.sort == []
    assert g |> Graph.edges == []
  end

  test "part 1 simple" do
    input = [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags."]

    assert Day07.part_1(input) == 4
  end

  test "Part 1" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day07/input.txt")
    assert Day07.part_1(input) == 296
  end

  test "part 2 simple" do
    input = [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags."]

    assert Day07.part_2(input) == 32
  end

  test "part 2 simple 2" do
    input = ["shiny gold bags contain 2 dark red bags.",
    "dark red bags contain 2 dark orange bags.",
    "dark orange bags contain 2 dark yellow bags.",
    "dark yellow bags contain 2 dark green bags.",
    "dark green bags contain 2 dark blue bags.",
    "dark blue bags contain 2 dark violet bags.",
    "dark violet bags contain no other bags."]

    assert Day07.part_2(input) == 126
  end

  test "Part 2" do
    input = FileUtils.get_file_as_strings("/Users/eric/src/aoc_2020/test/day07/input.txt")
    assert Day07.part_2(input) == 9339
  end
end
