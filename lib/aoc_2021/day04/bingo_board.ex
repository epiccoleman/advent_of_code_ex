defmodule Aoc2021.Day04.BingoBoard do
  @moduledoc """
  Defines a module for tracking a Bingo board.

  to start i'm just going to code it as a raw map of {x,y} => {number, marked?}
  i'm not sure this is the best approach but let's just code it and see.

  Another idea is that maybe it could just be a list of cells like [ { x: 0, y: 0, n: 0, marked?: false}]
  If it turns out that that looks easier I can just take the values I guess, let's stick with this idea for now

  Turns out it's easiest to key on numbers so far.

  it feels like it would be cool to use actors/message passing to implement the game, maybe an idea for later:
    see https://home.cs.colorado.edu/~kena/classes/5828/f16/lectures/13-actors.pdf

  couple ideas for how to build them
  input looks like this:

   22 13 17 11  0
    8  2 23  4 24
   21  9 14 16  7
    6 10  3 18  5
    1 12 20 15 19

  need functions to make boards, detect bingos, and to mark a number

  gonna follow the pattern from the grid module from 2020 and take a board as a list of strs

  """

  @doc """
  Creates a Bingo board from a list of strings, formatted like the puzzle input:

   22 13 17 11  0
    8  2 23  4 24
   21  9 14 16  7
    6 10  3 18  5
    1 12 20 15 19

  Requires 5x5 board spec like above.

  Returns a map of {x,y} => {n, marked?}
  """
  def from_strs(strs) do
    bingo_card_numbers =
      strs
        |> Enum.map(&(String.split(&1, " ", trim: true)))
        |> Enum.map(fn row ->
          Enum.map(row, &String.to_integer/1)
        end)

    for x <- 0..4,
        y <- 0..4 do
      {x,y}
      n = bingo_card_numbers |> Enum.at(y) |> Enum.at(x)
      # {{x, y}, %{number: n, marked?: false, row: y, col: x}} # if you wanted a map
      {n, %{number: n, marked?: false, row: y, col: x}}
    end
    |> Enum.into(%{}) # if you want a map
  end

  @doc """
  Takes in a Bingo Board, like the one you get from from_strs, and marks number.
  Does nothing if you pass a bad number.
  """
  def mark_number(board, number) do
    if Map.has_key?(board, number) do
      board
      |> Map.update!(number, &(Map.put(&1, :marked?, true)))
    else
      board
    end
  end

  def sum_unmarked_numbers(board) do
    board
    |> Map.values()
    |> Enum.reject(fn cell -> cell.marked? end)
    |> Enum.reduce(0, fn cell, acc -> acc + cell.number end)
  end

  @doc """
  Given a board, returns whether the board currently has a bingo.
  """
  def bingo?(board) do
    for i <- 0..4 do
      row = bingo_in_row?(board, i)
      col = bingo_in_col?(board, i)
      [row, col]
    end
    |> List.flatten()
    |> Enum.any?()
  end

  def bingo_in_row?(board, row_number) do
    board
    |> Map.values()
    |> Enum.filter(fn cell -> cell.row == row_number end)
    |> Enum.all?(fn cell -> cell.marked? end)
  end

  def bingo_in_col?(board, col_number) do
    board
    |> Map.values()
    |> Enum.filter(fn cell -> cell.col == col_number end)
    |> Enum.all?(fn cell -> cell.marked? end)
  end

end
