defmodule Aoc2021.Day05.Line do
  @moduledoc """
  Defines a struct and helper functions for representing Lines.
  """
  alias Aoc2021.Day05.Line
  defstruct x1: nil, x2: nil, y1: nil, y2: nil

    @doc """
    Given a string representing a line, as formatted in the puzzle input, converts it to a Line

    Returns: Line

    ## Examples
      iex> Line.from_str("682,519 -> 682,729")
      %Line{x1: 682, x2: 682, y1: 519, y2: 729}
    """
    @spec from_str(String.t()) :: %Line{}
    def from_str(line_str) do
      # named_captures is so filthy, love it
      captures = Regex.named_captures(~r/(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)/, line_str)

      %Line{
        x1: String.to_integer(captures["x1"]),
        x2: String.to_integer(captures["x2"]),
        y1: String.to_integer(captures["y1"]),
        y2: String.to_integer(captures["y2"]),
      }
    end

    @doc """
    Given a Line, returns a list of all (integer) points that the line covers.

    I'm not sure how this works for non-straight lines... I am assuming that the puzzle inputs only generate lines
    with integer slopes? For now I'll assume it's only going to be used for straight lines.

    ## Examples

      iex> enumerate_points(%Line{x1: 1, x2: 1, y1: 1, y2: 3})
      [{1, 1}, {1, 2}, {1, 3}]

      iex> enumerate_points(%Line{x1: 1, x2: -2, y1: 1, y2: 1})
      [{-2, 1}, {-1, 1}, {0, 1}, {1, 1}]

      iex> enumerate_points(%Line{x1: 1, x2: 3, y1: 1, y2: 3})
      [{1, 1}, {2, 2}, {3, 3}]

      iex> enumerate_points(%Line{x1: 3, x2: 1, y1: 3, y2: 1})
      [{3, 3}, {2, 2}, {1, 1}]
    """
    @spec enumerate_points(%Line{}) ::maybe_improper_list()
    def enumerate_points(%Line{x1: x1, x2: x2, y1: y1, y2: y2} = line) do
      cond do
        is_horizontal?(line) ->
          for x <- min(x1, x2)..max(x1, x2) do
            {x, y1}
          end
        is_vertical?(line) ->
          for y <- min(y1,y2)..max(y1, y2) do
            {x1, y}
          end
        true ->
          enumerate_diagonal_points(line)
      end
    end

    defp enumerate_diagonal_points(%Line{x1: x1, x2: x2, y1: y1, y2: y2}) do
      # the case where x1 == x2 or y1 == y2 should never happen here, so we want the error if it does
      x_step = cond do
        x1 < x2 -> 1
        x1 > x2 -> -1
      end
      y_step = cond do
        y1 < y2 -> 1
        y1 > y2 -> -1
      end

      Stream.iterate({x1, y1}, fn {x, y} -> {x + x_step, y + y_step} end)
      |> Stream.take_while(fn {x, y} -> (x - x_step) != x2 and (y - y_step) != y2 end)
      |> Enum.to_list()
    end

    def is_straight?(line) do
      is_horizontal?(line) or is_vertical?(line)
    end

    defp is_vertical?(%Line{x1: x1, x2: x2}) do
      x1 == x2
    end

    defp is_horizontal?(%Line{y1: y1, y2: y2}) do
      y1 == y2
    end

end
