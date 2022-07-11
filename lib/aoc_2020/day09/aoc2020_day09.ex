  defmodule Aoc2020.Day09 do
    alias Aoc2020.Day01

    def get_pairs(input, preamble_size) do
      input
      |> Enum.chunk_every(preamble_size + 1, 1, :discard)
      |> Enum.map(fn nums ->
        Enum.split(nums, preamble_size)
      end)
      |> Enum.map(fn { terms, [ target ]} ->
        pairs = Day01.find_pairs_that_sum(terms, target)

        %{pairs: pairs,
          target: target}
      end)
    end

    def find_weak_number(input, preamble_size) do
      get_pairs(input, preamble_size)
      |> Enum.find_value(fn
                      %{pairs: [], target: target } -> target;
                      %{pairs: _, target: _} -> nil;
                   end)
    end

    def find_encryption_weakness(input, target) do
      chonks = for chunk_size <- 2..617 do Enum.chunk_every(input, chunk_size, 1, :discard) end
      chonks
      |> List.foldl([], &(&1 ++ &2)) # flattens by one level
      |> Enum.find(fn chonk -> Enum.reduce(chonk, &+/2) == target end)
    end

    def part_1(input) do
      input
      |> find_weak_number(25)
    end

    def part_2(input) do
      {min, max} = input
      |> find_encryption_weakness(731031916)
      |> Enum.min_max()
      min + max
    end
  end
