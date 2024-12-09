defmodule Aoc2024.Day06Test do
  use ExUnit.Case
  import AocUtils.FileUtils
  import Aoc2024.Day06

  import Checkov
  alias AocUtils.Grid2D
  alias Aoc2024.Day06.GuardState

  test "process_input" do
    input = [
      ".#.",
      "#^#",
      ".#."
    ]

    expected_grid =
      Grid2D.from_strs(
        [
          ".#.",
          "#.#",
          ".#."
        ],
        ignore: "."
      )

    actual_guard_state = process_input(input)

    expected_guard_state = %GuardState{
      grid: expected_grid,
      guard_loc: {1, 1},
      guard_dir: :up,
      visited: MapSet.new(),
      visited_obstacles: []
    }

    assert actual_guard_state == expected_guard_state
  end

  test "turn_guard" do
    input = get_file_as_strings("./test/aoc_2024/day06/test_input.txt")
    guard_state = process_input(input)

    # guard starts facing up
    once = turn_guard(guard_state)
    twice = turn_guard(turn_guard(guard_state))
    thrice = turn_guard(turn_guard(turn_guard(guard_state)))
    niiiice = turn_guard(turn_guard(turn_guard(turn_guard(guard_state))))

    assert guard_state.guard_dir == :up
    assert once.guard_dir == :right
    assert twice.guard_dir == :down
    assert thrice.guard_dir == :left
    assert niiiice.guard_dir == :up
  end

  test "obstacle?" do
    input = [
      ".#.",
      "#^#",
      ".#."
    ]

    guard_state = process_input(input)

    assert obstacle?(guard_state)
    assert obstacle?(%{guard_state | guard_dir: :left})
    assert obstacle?(%{guard_state | guard_dir: :right})
    assert obstacle?(%{guard_state | guard_dir: :down})
    assert obstacle?(%{guard_state | guard_loc: {0, 0}, guard_dir: :right})
    assert not obstacle?(%{guard_state | guard_loc: {0, 0}})
  end

  test "simulate_guard simple" do
    input = [
      "...",
      "#^#",
      ".#."
    ]

    starting_state = process_input(input)

    expected_state = %GuardState{
      grid: starting_state.grid,
      visited: MapSet.new([{1, 1}, {1, 0}]),
      guard_loc: {1, -1},
      guard_dir: :up
    }

    actual_state = simulate_guard(starting_state)

    assert actual_state == expected_state
  end

  test "Part 1 test" do
    input = get_file_as_strings("./test/aoc_2024/day06/test_input.txt")
    assert part_1(input) == 41
  end

  test "Part 1" do
    input = get_file_as_strings("./test/aoc_2024/day06/input.txt")
    assert part_1(input) == 4559
  end

  data_test "has_cycle?" do
    assert has_cycle?(list) == result

    where([
      [:list, :result],
      [[1, 2, 3], false],
      [[1, 2, 3, 1, 2, 3], false],
      [[1, 2, 3, 4, 1, 2, 3, 5], false],
      [[1, 2, 3, 4, 1, 2, 3, 4], true]
    ])
  end

  test "simulate with cycle detection - exits grid" do
    input = [
      "...",
      "#^#",
      ".#."
    ]

    starting_state = process_input(input)
    assert {:exited, _} = simulate_guard_with_cycle_detection(starting_state)
  end

  test "simulate with cycle detection - finds cycle" do
    input = [
      ".#.",
      "#^#",
      ".#."
    ]

    starting_state = process_input(input)
    assert {:cycle, _} = simulate_guard_with_cycle_detection(starting_state)
  end

  test "simulate with cycle detection - finds cycle again" do
    input = [
      ".#..",
      ".^.#",
      "#...",
      "..#."
    ]

    starting_state = process_input(input)
    assert {:cycle, _} = simulate_guard_with_cycle_detection(starting_state)
  end

  test "Part 2 test" do
    input = get_file_as_strings("./test/aoc_2024/day06/test_input.txt")
    assert part_2(input) == 6
  end

  @tag slow: true
  test "Part 2" do
    input = get_file_as_strings("./test/aoc_2024/day06/input.txt")
    assert part_2(input) == 1604
  end
end
