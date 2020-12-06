  defmodule Day04 do
    def valid_passport?(passport_str) do
      String.contains?(passport_str, "ecl:") and
      String.contains?(passport_str, "pid:") and
      String.contains?(passport_str, "eyr:") and
      String.contains?(passport_str, "hcl:") and
      String.contains?(passport_str, "byr:") and
      String.contains?(passport_str, "iyr:") and
      String.contains?(passport_str, "hgt:")
    end

    def part_1(input) do
      input
      |> Enum.filter(&valid_passport?/1)
      |> Enum.count()
    end

    def part_2(input) do
      input
      |> Enum.map(&Day04.Passport.passport_from_str/1)
      |> Enum.filter(&Day04.Passport.is_valid?/1)
      |> Enum.count()
    end
  end
