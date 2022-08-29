defmodule Aoc2020.Day01 do
  def find_pairs_that_sum(input_list, n \\ 2020) do
    input_list
    |> Enum.map( fn x ->
      target = n - x
      search_result = Enum.filter(input_list, fn current -> current == target end)
      if not (Enum.empty?(search_result)) do
        { x , target }
      end
      end)
    |> Enum.reject(&is_nil/1)
  end

  def find_triple(input_list, n \\ 2020) do
    input_list
    |> Enum.map(fn x ->
      target = n - x
      candidates = Enum.filter(input_list, fn y -> y < target and y != x end)

      pairs = candidates |> find_pairs_that_sum(target)

      if !Enum.empty?(pairs) do
        { a, b } = pairs |> hd
        %{ target: target, tl_value: x, candidates: candidates, pairs: pairs, solution: x * a * b }
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> hd
  end

  @spec part_1(any) :: any
  def part_1(input) do
    {a, b} = input |> find_pairs_that_sum() |> hd()
    a*b
  end

  def part_2(input) do
    input |> find_triple() |> Map.get(:solution)
  end
end
