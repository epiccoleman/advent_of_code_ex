  defmodule Aoc2021.Day12 do
    @moduledoc """
    OK, well. This is obviously a graph problem, so at least we have a data structure to use.

    There are some disappointing things about graphlib though, and it looks like basically no one is maintaining it.
    It does not seem to be able to calculate paths on an undigraph, so the easy idea I had of enumerating all the paths
    and then filtering them manually won't work. It might make sense in graph theory terms that you can't enumerate paths
    on a cyclic undigraph, since you could theoretically construct infinitely many paths by iterating how many times you
    loop around a cycle. That's about as hard as I'm willing to think about that right now though.

    One thing that's _not_ disappointing about libgraph is that it has a built-in converter for its graphs to dot, which
    is the configuration language that graphviz uses, so it's quite easy to generate a visualization of the graph. Although I'm
    not sure it's particularly useful...

    Anyway, looks like I probably have to write my own traversal to take into account the logic of not revisiting caves.
    graphlib has built-in traversals for reducing or mapping over a graph, but I don't think they'll work for my case.
    """
    def input_to_graph(input) do
      edges =
        input
        |> Enum.map(fn edge_str ->
          [v1, v2] = String.split(edge_str, "-")

          # we want single directions from start and to end, maybe?
          if v1 == "start" or v2 == "end" do
            {v1, v2}
          else
            [ {v1, v2}, {v2, v1} ]
          end
        end)
        |> List.flatten()

      Graph.new()
      |> Graph.add_edges(edges)
    end

    def is_small_cave?(cave) do
      cave =~ ~r/[a-z]/
    end

    @doc """
    Traverse the graph of caves, building up a list of possible paths as we go.

    Current problem with this is that it returns a deeply nested list, which I have not quite figured out how to rip apart yet
    """
    def paths(graph) do
      paths(graph, "start")
    end

    def paths(graph, current_v, visited \\ []) # yuck, i don't like this
    def paths(_graph, "end", visited) do
      visited ++ ["end"]
    end

    def paths(graph, current_v, visited) do
      new_visited = visited ++ [current_v]

      out_edges =
        Graph.out_edges(graph, current_v)
        |> Enum.reject(fn %{v2: next_v} ->
          next_v in visited and is_small_cave?(next_v) # we only visit small caves a max of once
        end)

      if Enum.empty?(out_edges) do
        []
      else
        Enum.map(out_edges, fn %{v2: next_v} ->
          paths(graph, next_v, new_visited)
        end)
      end
    end

    def flattenize(list) do
      if Enum.all?(list, &is_list/1) do
        Enum.map(list, fn l ->
          List.foldl(l, [], &(&1 ++ &2)) # flattens by one level
          |> flattenize()
        end)
      else
        list
      end
      # if List.flatten(list) == list do
      #   list
      # else
      #   Enum.map(list, fn l ->
      #     List.foldl(l, [], &(&1 ++ &2)) # flattens by one level
      #     |> flattenize()
      #   end)
      # end
    end

    @doc """
    Given a deeply nested list of paths, cheaply counts the distinct paths by flattening it and counting how many
    "ends" there are
    """
    def count_paths_cheaty(paths) do
      paths
      |> List.flatten()
      |> Enum.count(&(&1 == "end"))
    end

    def part_1(input) do
      input
      |> input_to_graph()
      |> paths()
      |> count_paths_cheaty()
    end

    def part_2(input) do
      input
    end
  end
