defmodule Day11Test do
  use ExUnit.Case

  import Day11

  test "to_seat_map" do
    input = [
      "L.L",
      "LLL",
      "L.L"
    ]

    assert to_seat_map(input) ==
      %{{0,0} => "L", {1, 0} => ".", {2, 0} => "L",
        {0,1} => "L", {1, 1} => "L", {2, 1} => "L",
        {0,2} => "L", {1, 2} => ".", {2, 2} => "L",}
  end

  test "neighbors" do
    input = [
      "L.L",
      "LLL",
      "L.L"
    ] |> to_seat_map()

    assert neighbors(input, {1, 1}) |> Enum.sort  == ["L", ".", "L", "L", "L", "L", ".", "L"] |> Enum.sort
  end

  test "count_occupied_neighbors 0" do
    input = [
      "L..",
      "L#L",
      "L.."
    ] |> to_seat_map()

    assert count_occupied_neighbors(input, {1, 1}) == 0
  end

  test "count_occupied_neighbors 4" do
    input = [
      "L.#",
      "##L",
      "#.#"
    ] |> to_seat_map()

    assert count_occupied_neighbors(input, {1, 1}) == 4
  end

  test "next_cell_state, empty -> occupied" do
    input = [
      "L.L",
      "LLL",
      "L.L"
    ] |> to_seat_map()

    assert next_cell_state(input, {1, 1}) == "#"
  end

  test "next_cell_state, empty -> empty" do
    input = [
      "L.L",
      "#LL",
      "L.L"
    ] |> to_seat_map()

    assert next_cell_state(input, {1, 1}) == "L"
  end

  test "next_cell_state, occupied -> empty" do
    input = [
      "L#L",
      "###",
      "L#L"
    ] |> to_seat_map()

    assert next_cell_state(input, {1, 1}) == "L"
  end

  test "next_cell_state floor" do
    input = [
      "L.L",
      "L.L",
      "L.L"
    ] |> to_seat_map()

    assert next_cell_state(input, {1, 1}) == "."
  end

  test "next_board_state" do
    input = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL" ] |> to_seat_map()

    expected = [
      "#.##.##.##",
      "#######.##",
      "#.#.#..#..",
      "####.##.##",
      "#.##.##.##",
      "#.#####.##",
      "..#.#.....",
      "##########",
      "#.######.#",
      "#.#####.##"
    ] |> to_seat_map()

    assert next_board_state(input) == expected


  end

  test "double next board state" do
    input = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL" ] |> to_seat_map()

    expected = [
      "#.LL.L#.##",
      "#LLLLLL.L#",
      "L.L.L..L..",
      "#LLL.LL.L#",
      "#.LL.LL.LL",
      "#.LLLL#.##",
      "..L.L.....",
      "#LLLLLLLL#",
      "#.LLLLLL.L",
      "#.#LLLL.##"
    ] |> to_seat_map()

    result =
      input
      |> next_board_state()
      |> next_board_state()

    assert result == expected
  end

  test "simulate_until_no_change" do
    input = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL" ] |> to_seat_map()

    expected = ["#.#L.L#.##", "#LLL#LL.L#", "L.#.L..#..", "#L##.##.L#", "#.#L.LL.LL",
    "#.#L#L#.##", "..L.L.....", "#L#L##L#L#", "#.LLLLLL.L", "#.#L#L#.##"] |> to_seat_map()

    assert simulate_until_no_change(input, MapSet.new) == expected

  end

  test "count_visible_seats" do
    seat_map = [
      ".......#.",
      "...#.....",
      ".#.......",
      ".........",
      "..#L....#",
      "....#....",
      ".........",
      "#........",
      "...#....."
    ] |> to_seat_map()

    assert count_visible_seats(seat_map, {3, 4}) == 8
  end

  test "count_visible_seats again" do
    seat_map = [".##.##.", "#.#.#.#", "##...##", "...L...", "##...##", "#.#.#.#", ".##.##."] |> to_seat_map()

    assert count_visible_seats(seat_map, {3, 3}) == 0
  end

  test "count_visible_seats obstructed" do
    seat_map = [
      ".............",
      ".L.L.#.#.#.#.",
      "............." ] |> to_seat_map()

    assert count_visible_seats(seat_map, {1, 1} )== 0
  end

  test "next_board_state_2" do
    input = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL" ] |> to_seat_map()

    expected = [
      "#.##.##.##",
      "#######.##",
      "#.#.#..#..",
      "####.##.##",
      "#.##.##.##",
      "#.#####.##",
      "..#.#.....",
      "##########",
      "#.######.#",
      "#.#####.##"
    ] |> to_seat_map()

    assert next_board_state_2(input) == expected
  end

  test "double nexdt board state 2" do
    input = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL" ] |> to_seat_map()

    expected = ["#.LL.LL.L#", "#LLLLLL.LL", "L.L.L..L..", "LLLL.LL.LL", "L.LL.LL.LL",
    "L.LLLLL.LL", "..L.L.....", "LLLLLLLLL#", "#.LLLLLL.L", "#.LLLLL.L#" ] |> to_seat_map()

    assert next_board_state_2(next_board_state_2(input)) == expected
  end

  test "part 2 small" do
    input = [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL" ]

    assert Day11.part_2(input) == 26
  end

  @tag slow: true
  test "Part 1" do
    input = AOCUtils.FileUtils.get_file_as_strings("test/day11/input.txt")
    assert Day11.part_1(input) == 2183
  end

  @tag slow: true
  @tag timeout: 120000
  test "Part 2" do
    input = AOCUtils.FileUtils.get_file_as_strings("test/day11/input.txt")
    assert Day11.part_2(input) == 1990
  end
end
