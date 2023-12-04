defmodule Aoc2023.Day02 do
  def process_line(line) do
    [id_chunk, pulls_chunk] = String.split(line, ": ")

    [_, id_str] = String.split(id_chunk, " ")

    pulls =
      String.split(pulls_chunk, "; ")
      |> Enum.map(&process_pull/1)

    %{id: String.to_integer(id_str), pulls: pulls}
  end

  @doc """
  Turns a string representing one "turn" in the game - a "pull" of cubes from the bag -
  into a map representation. All possible colors (red, green, blue) are guaranteed to
  be represented in the pull, defaulting to 0 if no cubes of a given color were
  pulled from the bag.
  """
  def process_pull(pull_str) do
    pull =
      pull_str
      |> String.split(", ")
      |> Enum.reduce(%{}, fn chonk, acc ->
        [n_str, color] = String.split(chonk, " ")
        Map.put(acc, String.to_atom(color), String.to_integer(n_str))
      end)

    Map.merge(%{red: 0, green: 0, blue: 0}, pull)
  end

  @doc """
  Checks if the given game would be possible with the given limitations
  for cubes in the bag. If a pull exists where the color pulled was higher than
  the limit, this is false.
  """
  def game_within_limit?(game, red_limit, green_limit, blue_limit) do
    not Enum.any?(game.pulls, fn pull ->
      pull.green > green_limit or
        pull.blue > blue_limit or
        pull.red > red_limit
    end)
  end

  @doc """
  Calculates the minimum number of each color of cube that are necessary to play
  a given game.
  """
  def minimal_cubes(game) do
    game.pulls
    |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn pull, acc ->
      %{
        red: max(acc.red, pull.red),
        green: max(acc.green, pull.green),
        blue: max(acc.blue, pull.blue)
      }
    end)
  end

  @doc """
  Calculates the "power" of a game -
  The power of a set of cubes is equal to the numbers of red, green,
  and blue cubes multiplied together. The power of a "game" is the power of
  the minimal set of cubes that would be needed to play that game.
  """
  def game_power(game) do
    minimal_cubes(game)
    |> Enum.reduce(1, fn {_, n}, acc -> n * acc end)
  end

  def part_1(input) do
    red_limit = 12
    green_limit = 13
    blue_limit = 14

    input
    |> Enum.map(&process_line/1)
    |> Enum.filter(fn game ->
      game_within_limit?(game, red_limit, green_limit, blue_limit)
    end)
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Enum.map(&process_line/1)
    |> Enum.map(&game_power/1)
    |> Enum.sum()
  end
end
