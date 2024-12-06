defmodule Aoc2024.Day05 do
  @doc """
  Process the lines from the input file into two separate components -
  rules, and updates
  """
  def process_input(input) do
    split_index = Enum.find_index(input, &(&1 == ""))

    rules_strs = Enum.slice(input, 0, split_index)
    update_strs = Enum.slice(input, split_index + 1, length(input))

    rules =
      rules_strs
      |> Enum.map(fn rule_str ->
        String.split(rule_str, "|")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    updates =
      update_strs
      |> Enum.map(fn update_str ->
        String.split(update_str, ",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  def rule_relevant?({a, b} = _rule, update) do
    a in update and b in update
  end

  def update_valid_for_rule?(update, {a, b} = _rule) do
    a_index = Enum.find_index(update, &(&1 == a))
    b_index = Enum.find_index(update, &(&1 == b))

    a_index < b_index
  end

  def update_valid?(update, rules) do
    relevant_rules = Enum.filter(rules, &rule_relevant?(&1, update))
    Enum.all?(relevant_rules, &update_valid_for_rule?(update, &1))
  end

  def middle_num(update) do
    if(length(update) < 3 or rem(length(update), 2) == 0) do
      raise("what the hell you doin")
    end

    midpoint = floor(length(update) / 2)
    Enum.at(update, midpoint)
  end

  def part_1(input) do
    {rules, updates} = process_input(input)

    Enum.filter(updates, fn update ->
      update_valid?(update, rules)
    end)
    |> Enum.map(&middle_num/1)
    |> Enum.sum()
  end

  def rules_to_graph(rules) do
    graph = Graph.new(type: :directed)

    rules
    |> Enum.reduce(graph, fn {a, b} = _rule, graph ->
      Graph.add_edge(graph, a, b)
    end)
  end

  def rearrange_update(update, sort_order) do
    Enum.reduce(sort_order, [], fn v, acc ->
      if v in update do
        acc ++ [v]
      else
        acc
      end
    end)
  end

  def part_2(input) do
    {rules, updates} = process_input(input)

    # rules_sort =
    #   rules
    #   |> rules_to_graph()
    #   |> Graph.topsort()

    updates
    |> Enum.reject(fn update ->
      update_valid?(update, rules)
    end)
    |> Enum.map(fn update ->
      relevant_rules = Enum.filter(rules, &rule_relevant?(&1, update))

      sort_order =
        relevant_rules
        |> rules_to_graph()
        |> Graph.topsort()

      rearrange_update(update, sort_order)
    end)
    |> Enum.map(&middle_num/1)
    |> Enum.sum()
  end
end
