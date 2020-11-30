defmodule Warmup do
  def calculate_fuel_requirement(mass) do
    Float.floor(((mass * 1.0) / 3)) - 2
  end

  def calculate_tyrannical(mass, acc \\ 0) do
    fuel_requirement = calculate_fuel_requirement(mass)
    if fuel_requirement <= 0 do
      acc
    else
      calculate_tyrannical(fuel_requirement, acc + fuel_requirement)
    end
  end

  def part_1(input) do
    input
    |> Enum.map(&calculate_fuel_requirement/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Enum.map(&calculate_tyrannical/1)
    |> Enum.sum()
  end
end
