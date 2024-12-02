defmodule Aoc2024.Day02 do
  @doc """
  Given a list of input lines, convert the lines to "reports" (a list of numbers)
  """
  def input_to_reports(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  A report is safe if:
  all numbers are either increasing or decreasing
  successive levels differ by at least one and no more than three
  """
  def report_safe?(report) do
    chonks = Enum.chunk_every(report, 2, 1, :discard)

    decreasing? = Enum.all?(chonks, fn [a, b] -> a > b end)
    increasing? = Enum.all?(chonks, fn [a, b] -> a < b end)

    gradual? =
      Enum.all?(chonks, fn [a, b] ->
        difference = abs(a - b)
        difference <= 3 and difference >= 1
      end)

    (increasing? or decreasing?) and gradual?
  end

  @doc """
  The "problem dampener" can allow a report to be safe if removing one value would make it safe.

  To "dampen" a report, we just generate a list of possible removals, then the safety check func for
  part 2 can test those to see if a report is safe when dampened.
  """
  def moisten_report(report) do
    # moist and damp are synonyms ( ͡º ͜ʖ ͡º )
    for n <- 0..(length(report) - 1), do: List.delete_at(report, n)
  end

  def report_safe_with_dampening?(report) do
    report_safe?(report) or Enum.any?(moisten_report(report), &report_safe?/1)
  end

  def part_1(input) do
    input
    |> input_to_reports()
    |> Enum.filter(&report_safe?/1)
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> input_to_reports()
    |> Enum.filter(&report_safe_with_dampening?/1)
    |> Enum.count()
  end
end
