  defmodule Day07 do

    def process_line(graph, input_str) do
      [v1, rest] = String.split(input_str, " bags contain ")

      edges = rest
      |> String.split(", ")
      |> Enum.map(fn v2_str ->

        if v2_str == "no other bags." do
          nil
        else
          [ bag_weight, bag_color_adj, bag_color, _] = v2_str |> String.split(" ")
          weight = bag_weight |> String.to_integer()
          v2 = bag_color_adj <> " " <> bag_color

          {v1, v2, weight: weight}
        end

      end)
      |> Enum.reject(&is_nil/1)
      Graph.add_edges(graph, edges)
    end

    def graph_from_input_strs(input) do
      input
      |> Enum.reduce(Graph.new(), fn input_str, g ->
        process_line(g, input_str)
      end)
    end

    def bags_held(g, v) do
      out_edges = Graph.out_edges(g, v)
      if Enum.empty?(out_edges) do
        1
      else
        (Enum.map(out_edges, fn e ->
          e.weight * bags_held(g, e.v2)
        end)
        |> Enum.reduce(&+/2)) + 1 # to account for the bag itself... but the problem here is that you get a +1 for the starting bag
      end
    end

    def part_1(input) do
      graph = graph_from_input_strs(input)

      graph
      |> Graph.reaching_neighbors(["shiny gold"])
      |> Enum.count
    end

    def part_2(input) do
      graph = input
      |> Enum.reduce(Graph.new(), fn input_str, g ->
        process_line(g, input_str)
      end)

      bags_held(graph, "shiny gold") - 1 #due to impl of bags_held we count the outermost bag, so take off 1 to correct for that
    end
  end
