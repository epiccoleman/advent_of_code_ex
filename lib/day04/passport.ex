defmodule Day04.Passport do
  alias Day04.Passport

  defstruct ecl: nil, eyr: nil, pid: nil, hcl: nil, byr: nil, iyr: nil, cid: nil, hgt: nil
  def passport_from_str(passport_str) do
    props = passport_str
      |> String.split(" ")
      |> Enum.map(fn property ->
        [ prop, value ] = String.split(property, ":")
        {String.to_atom(prop), value}  end)

    struct(Day04.Passport, props)
  end

  def is_valid?(passport) do
    ecl_valid?(passport) and
    pid_valid?(passport) and
    eyr_valid?(passport) and
    hcl_valid?(passport) and
    byr_valid?(passport) and
    iyr_valid?(passport) and
    hgt_valid?(passport)
  end

   def ecl_valid?(%Passport{ecl: ecl}) do
    not is_nil(ecl) and
    Enum.member?([
      "amb", "blu", "brn", "gry", "grn", "hzl", "oth"
    ], ecl)
   end

   def pid_valid?(%Passport{pid: pid}) do
    not is_nil(pid) and
    String.length(pid) == 9 and
    Integer.parse(pid) != :error
   end

   def eyr_valid?(%Passport{eyr: eyr}) do
    not is_nil(eyr) and
    n_digits?(eyr, 4) and
    String.to_integer(eyr) in 2020..2030
   end

   def hcl_valid?(%Passport{hcl: hcl}) do
    not is_nil(hcl) and
    String.graphemes(hcl) |> Enum.at(0) == "#" and
    String.slice(hcl, 1, 6) =~ ~r([a-f|0-9]{6})
   end

   def byr_valid?(%Passport{byr: byr}) do
    not is_nil(byr) and
    n_digits?(byr, 4) and
    String.to_integer(byr) in 1920..2002
   end

   def iyr_valid?(%Passport{iyr: iyr}) do
    not is_nil(iyr) and
    n_digits?(iyr, 4) and
    String.to_integer(iyr) in 2010..2020
   end

   def hgt_valid?(%Passport{hgt: hgt}) do
    if is_nil(hgt) do
      false
    else
      unit = String.slice(hgt, -2, 2)
      number = case String.slice(hgt, 0, String.length(hgt) - 2) |> Integer.parse() do
        :error -> :error
        {num, _} -> num
      end

      if number != :error do
        case unit do
          "cm" -> number in 150..193
          "in" -> number in 59..76
          _ -> false
        end
      else
        false
      end
    end
   end

   defp n_digits?(number, n) do
    (to_string(number) |> String.length()) == n
   end
end
