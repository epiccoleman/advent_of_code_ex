  defmodule Aoc2021.Day03 do
    def most_common_in_column(column_i, strings) do
      column_bits = strings
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&(Enum.at(&1, column_i)))

      zero_count = Enum.count(column_bits, &(&1 == "0"))
      one_count = Enum.count(column_bits, &(&1 == "1"))

      if zero_count > one_count do
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
      #probably could use Enum.with_index for this but idk, this read easier
      bit_count = input |> hd |> String.length()

      epsilon_number_string =
        0..bit_count-1
        |> Enum.map(&(least_common_in_column(&1, input)))
        |> Enum.join()

      {epsilon, _} = Integer.parse(epsilon_number_string, 2)

      epsilon
    end

    def calculate_power_consumption(input) do
        gamma = calculate_gamma(input)
        epsilon = calculate_epsilon(input)

        gamma * epsilon
    end

    # part 2
    @doc "given a list of strings, return the strings for which the given column contains bit"
    def filter_by_bit_and_column(input, bit, column) do
      input
      |> Enum.filter(fn s ->
        s
        |> String.graphemes()
        |> Enum.at(column) == bit
      end)
    end

    def calculate_oxygen_generator_rating(input) do
      o_rating_str = find_o_rating(input, 0)
      {o_rating, _} = Integer.parse(o_rating_str, 2)
      o_rating
    end

    def find_o_rating(input, column) do
      if length(input) == 1 do
        hd(input)
      else
        search_value = most_common_in_column(column, input)
        new_list = filter_by_bit_and_column(input, search_value, column)
        find_o_rating(new_list, column + 1)
      end
    end

    def calculate_co2_scrubber_rating(input) do
      co2_rating_str = find_co2_rating(input, 0)
      {co2_rating, _} = Integer.parse(co2_rating_str, 2)
      co2_rating
    end

    def find_co2_rating(input, column) do
      # IO.puts("calling find with input l: #{length(input)} and for column: #{column}")
      if length(input) == 1 do
        hd(input)
      else
        search_value = least_common_in_column(column, input)
        new_list = filter_by_bit_and_column(input, search_value, column)
        find_co2_rating(new_list, column + 1)
      end
    end

    def calculate_life_support_rating(input) do
      o_generator_rating = calculate_oxygen_generator_rating(input)
      co2_scrubber_rating = calculate_co2_scrubber_rating(input)

      o_generator_rating * co2_scrubber_rating
    end

    def part_1(input) do
      calculate_power_consumption(input)
    end

    def part_2(input) do
      calculate_life_support_rating(input)
    end
  end
