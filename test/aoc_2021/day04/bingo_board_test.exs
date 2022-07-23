defmodule Aoc2021.BingoBoardTest do
  use ExUnit.Case
  import Aoc2021.Day04.BingoBoard

  @test_bingo_board_str """
    22 13 17 11  0
    8  2 23  4 24
    21  9 14 16  7
    6 10  3 18  5
    1 12 20 15 19
  """

  test "from_strs" do
    board_strs = String.split(@test_bingo_board_str, "\n")
    board = from_strs(board_strs)

    one = Map.get(board, 1)

    assert one == %{col: 0, row: 4, marked?: false, number: 1}
  end

  test "mark_number" do
    board_strs = String.split(@test_bingo_board_str, "\n")
    board =
      from_strs(board_strs)
      |> mark_number(1)

    one = Map.get(board, 1)
    assert one == %{col: 0, row: 4, marked?: true, number: 1}
  end

  test "bingo_in_row?" do
    board_strs = String.split(@test_bingo_board_str, "\n")
    board =
      from_strs(board_strs)
      |> mark_number(22)
      |> mark_number(13)
      |> mark_number(17)
      |> mark_number(11)
      |> mark_number(0)

    assert bingo_in_row?(board, 0)
  end

  test "bingo_in_col?" do
    board_strs = String.split(@test_bingo_board_str, "\n")
    board =
      from_strs(board_strs)
      |> mark_number(22)
      |> mark_number(8)
      |> mark_number(21)
      |> mark_number(6)
      |> mark_number(1)

    assert bingo_in_col?(board, 0)
  end

  test "bingo?" do
    board_strs = String.split(@test_bingo_board_str, "\n")
    board = from_strs(board_strs)

    board_1 =
      board
      |> mark_number(22)
      |> mark_number(8)
      |> mark_number(21)
      |> mark_number(6)
      |> mark_number(1)

    board_2 =
      board
      |> mark_number(17)
      |> mark_number(23)
      |> mark_number(14)
      |> mark_number(3)
      |> mark_number(20)

    board_3 =
      board
      |> mark_number(17)
      |> mark_number(3)
      |> mark_number(20)

    assert bingo?(board_1)
    assert bingo?(board_2)
    assert !bingo?(board_3)
  end

  test "sum_unmarked_numbers" do
    board_strs = String.split(@test_bingo_board_str, "\n")
    board =
      from_strs(board_strs)

    assert sum_unmarked_numbers(board) == 300

    board = mark_number(board, 20)
    assert sum_unmarked_numbers(board) == 280

    board = mark_number(board, 15)
    assert sum_unmarked_numbers(board) == 265

    board =
      board
      |> mark_number(1)
      |> mark_number(2)
      |> mark_number(3)
      |> mark_number(4)

    assert sum_unmarked_numbers(board) == 255
  end
end
