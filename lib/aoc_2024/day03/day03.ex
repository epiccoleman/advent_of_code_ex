defmodule Aoc2024.Day03 do
  @mul_regex ~r/mul\(\d+,\d+\)/
  def find_mul_instructions(input) do
    Regex.scan(@mul_regex, input) |> List.flatten()
  end

  def strip_donts(input) do
    # make sure to use the ? for non-greedy match
    # we also use the `/s` at the end of the regex to ensure our
    # regex will match across lines
    dontdo_regex = ~r/don't\(\).*?do\(\)/s

    # this turned out to not be technically necessary, but it feels
    # righter to leave it in.
    trailing_dont_regex = ~r/don't\(\).*$/s

    input
    |> then(fn str -> Regex.replace(dontdo_regex, str, "") end)
    |> then(fn str -> Regex.replace(trailing_dont_regex, str, "") end)
  end

  def do_mul(mul_str) do
    if not Regex.match?(@mul_regex, mul_str), do: throw("you blew it")

    Regex.scan(~r/\d+/, mul_str)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> then(fn [a, b] -> a * b end)
  end

  def part_1(input) do
    input
    |> find_mul_instructions()
    |> Enum.map(&do_mul/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> strip_donts()
    |> find_mul_instructions()
    |> Enum.map(&do_mul/1)
    |> Enum.sum()
  end
end
