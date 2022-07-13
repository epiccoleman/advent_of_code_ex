  defmodule Aoc2021.Day03 do
    def most_common_in_column(column_i, strings) do
      column_bits = strings
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&(Enum.at(&1, column_i)))

      zero_count = Enum.count(column_bits, &(&1 == "0"))
      one_count = Enum.count(column_bits, &(&1 == "1"))

      if zero_count >= one_count do
        "0"
      else
        "1"
      end
    end

    def least_common_in_column(column_i, strings) do
      column_bits = strings
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&(Enum.at(&1, column_i)))

      zero_count = Enum.count(column_bits, &(&1 == "0"))
      one_count = Enum.count(column_bits, &(&1 == "1"))

      if zero_count > one_count do
        "1"
      else
        "0"
      end
    end

    def calculate_gamma(input) do
      bit_count = input |> hd |> String.length()

      gamma_number_string =
        0..bit_count-1
        |> Enum.map(&(most_common_in_column(&1, input)))
        |> Enum.join()

      {gamma, _} = Integer.parse(gamma_number_string, 2)

      gamma
    end

    def calculate_epsilon(input) do
      bit_count = input |> hd |> String.length()

      epsilon_number_string =
        0..bit_count-1
        |> Enum.map(&(least_common_in_column(&1, input)))
        |> Enum.join()

      {epsilon, _} = Integer.parse(epsilon_number_string, 2)

      epsilon
    end

    def part_1(input) do
        gamma = calculate_gamma(input)
        epsilon = calculate_epsilon(input)

        gamma * epsilon
    end

    def part_2(input) do
      input
    end
  end
