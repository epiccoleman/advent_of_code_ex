defmodule Day21 do

  def parse_input_line(line) do
    [ ingredients_str, allergens_str ] = String.split(line, " (contains ")

    ingredients =
      ingredients_str
      |> String.split(" ")
      |> MapSet.new

    allergens =
      allergens_str
      |> String.trim(")")
      |> String.split(", ")

    {ingredients, allergens}
  end

  def parse_input(input_lines) do
    Enum.map(input_lines, &parse_input_line/1)
  end

  def all_allergens(food_list) do
    food_list
    |> Enum.flat_map(fn {_, allergens} -> allergens end)
    |> MapSet.new()
  end

  def all_ingredients(food_list) do
    food_list
    |> Enum.flat_map(fn {ingredients, _} -> ingredients end)
    |> MapSet.new()
  end

  def possible_ingredients_for_allergen(food_list, allergen) do
    possibles =
      food_list
      |> Enum.filter(fn {_ingredients, allergens} -> allergen in allergens end)
      |> Enum.map(fn {ingreds, _} -> ingreds end)
      |> Enum.reduce(all_ingredients(food_list), fn ing_set,acc -> MapSet.intersection(acc, ing_set) end)

    {allergen, possibles}
  end

  def all_possible_ingredients_for_all_allergens(food_list) do
    food_list
    |> all_allergens()
    |> Enum.map(fn allergen -> possible_ingredients_for_allergen(food_list, allergen) end)
  end

  def remove_option(possibles, ingredient) do
    possibles
    |> Enum.map(fn {i, set} ->
      {i,
        MapSet.delete(set, ingredient)
      }
    end)
  end

  def determine_allergens(possibles, result \\ %{}) do
    if Enum.empty?(possibles) do
      result
    else
      # find the field name with one possibility.
      {allergen, ingredient} = Enum.filter(possibles, fn {_, set} ->
        MapSet.size(set) == 1
      end)
      |> Enum.map(fn {allergen, ingredient_set} -> {allergen, hd(MapSet.to_list(ingredient_set))} end) |> hd

      # whittle down possibles by removing the known one we just found:
      new_possibles =
        possibles
        |> remove_option(ingredient)
        |> Enum.filter(fn {_, set} -> MapSet.size(set) > 0 end)

      new_result = result |> Map.put(allergen, ingredient)

      # do it again
      determine_allergens(new_possibles, new_result)
    end
  end


  def part_1(input) do
    food_list =
      input
      |> parse_input()

    ingredients_that_may_be_allergens =
      all_possible_ingredients_for_all_allergens(food_list)
      |> Enum.reduce(MapSet.new, fn {_, ings},acc -> MapSet.union(acc, ings) end)

    ingredients_that_cant_be_allergens =
      MapSet.difference(all_ingredients(food_list), ingredients_that_may_be_allergens)

    Enum.reduce(food_list, [], fn {ings, _},acc ->
      acc ++ MapSet.to_list(ings)
    end )
    |> Enum.count(fn ingredient -> ingredient in ingredients_that_cant_be_allergens end)

  end

  def part_2(input) do
    input
    |> parse_input()
    |> all_possible_ingredients_for_all_allergens()
    |> determine_allergens()
    |> Enum.reduce("", fn {_, ingredient}, acc -> acc <> ingredient <> "," end)
  end
end
