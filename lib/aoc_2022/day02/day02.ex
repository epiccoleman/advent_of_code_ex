defmodule Aoc2022.Day02 do
  @shape_scores %{
    "rock" => 1,
    "paper" => 2,
    "scissors" => 3,
  }

  @letter_to_move %{
    "A" => "rock",
    "X" => "rock",
    "B" => "paper",
    "Y" => "paper",
    "C" => "scissors",
    "Z" => "scissors"
  }

  @letter_to_result %{
    "X" => :lose,
    "Y" => :draw,
    "Z" => :win
  }

  @doc """
  Turn the input lines into a list of lists, where each list contains [player1_move, player2_move]
  """
  def process_input_part_1(input) do
    input
    |> Enum.map(fn input_line ->
       [p1_move, p2_move] = String.split(input_line, " ")
       [@letter_to_move[p1_move], @letter_to_move[p2_move]]
    end)
  end

  def process_input_part_2(input) do
    input
    |> Enum.map(fn input_line ->
       [p1_move, p2_move] = String.split(input_line, " ")
       [@letter_to_move[p1_move], @letter_to_result[p2_move]]
    end)
  end

  @doc """
  Returns the score for a single round of Rock Paper Scissors given a list containing "move codes"
  for the two players.

  Move codes:
  | Move     | p1 | p2 |
  |----------------|
  | Rock     | A  | X  |
  | Paper    | B  | Y  |
  | Scissors | C  | Z  |

  Scoring rules are as follows:

  The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors)
  plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).
  """

  def play_rps([p1_move, p2_move]) do
    case {p1_move, p2_move} do
      {"rock", "scissors"} -> :lose
      {"rock", "paper"} -> :win
      {"scissors", "rock"} -> :win
      {"scissors", "paper"} -> :lose
      {"paper", "rock"} -> :lose
      {"paper", "scissors"} -> :win
      _ -> :draw
    end
  end

  def score_round([p1_move, p2_move] = moves) do
    round_score = case play_rps(moves) do
      :win -> 6
      :draw -> 3
      :lose -> 0
    end

    shape_score = @shape_scores[p2_move]

    round_score + shape_score
  end

  @wins_against %{
    "rock" => "paper",
    "paper" => "scissors",
    "scissors" => "rock"
  }

  @loses_against %{
    "rock" => "scissors",
    "paper" => "rock",
    "scissors" => "paper"
  }

  def decide_move([p1_move, desired_result]) do
    move_to_play = case desired_result do
      :draw -> p1_move
      :win -> @wins_against[p1_move]
      :lose -> @loses_against[p1_move]
    end

    score_round([p1_move, move_to_play])
  end

  def part_1(input) do
    input
    |> process_input_part_1()
    |> Enum.map(&score_round/1)
    |> Enum.sum
  end

  def part_2(input) do
    input
    |> process_input_part_2()
    |> Enum.map(&decide_move/1)
    |> Enum.sum
  end
end
