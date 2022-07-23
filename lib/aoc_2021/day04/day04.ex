  defmodule Aoc2021.Day04 do
    alias Aoc2021.Day04.BingoBoard, as: Board

    @doc """
    takes input as a single string from a file (i.e. the results of a File.read! call)
    """
    def process_input(input) do
      [ numbers_str | board_strs ] =
        input
        |> String.split("\n\n")

      called_numbers =
        numbers_str
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      boards =
        board_strs
        |> Enum.map(fn board_str -> String.split(board_str, "\n") end) # this might belong in the from_strs but oh well
        |> Enum.map(&Board.from_strs/1)

      { called_numbers, boards }
    end

    def find_winning_board([current_number | called_numbers], boards) do
      # take the current number
      # mark it on all boards
      marked_boards =
        boards
        |> Enum.map(fn board -> Board.mark_number(board, current_number) end)

      # check for winners
      winner =
        marked_boards
        |> Enum.filter(fn board -> Board.bingo?(board) end)

      # if no winners, play next round
      if Enum.empty?(winner) do
        find_winning_board(called_numbers, marked_boards)
      else
        # else, return the winning board and the last number called
        { current_number, hd(winner) }
      end
    end

    # this shouldn't ever happen afaict, but just in case
    def find_winning_board([], boards) do
      { 0, hd(boards) }
    end

    def find_last_winning_board([current_number | called_numbers], boards) do
      # take the current number
      # mark it on all boards
      marked_boards =
        boards
        |> Enum.map(fn board -> Board.mark_number(board, current_number) end)

      # if there's a winner, remove it (or them)
      loser_boards =
        marked_boards
        |> Enum.reject(fn board -> Board.bingo?(board) end)

      #then continue, until only one board remains, and it has won
      if length(loser_boards) == 1 do
        find_winning_board(called_numbers, loser_boards)
      else
        find_last_winning_board(called_numbers, loser_boards)
      end
    end

    def part_1(input) do
      { called_numbers, boards } =
        input
        |> process_input()

      { last_num, winning_board } = find_winning_board(called_numbers, boards)

      last_num * Board.sum_unmarked_numbers(winning_board)
    end

    def part_2(input) do
      { called_numbers, boards } =
        input
        |> process_input()

      { last_num, winning_board } = find_last_winning_board(called_numbers, boards)

      last_num * Board.sum_unmarked_numbers(winning_board)
    end
  end
