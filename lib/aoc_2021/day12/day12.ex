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

    ===

    Day 2
    Alright, last night my laptop died and forced me to take a break, so here I am again ready to finish this damn thing.

    One thing I just thought of that I wanted to write down - constructing the graph as a digraph made things a little easier.
    The trick was that "start" and "end" only have edges in one direction. I wound up just taking that into account when
    processing the input which makes the recursion simpler. libgraph is missing some functionality around undigraphs and I guess
    this kind of thing is why, because writing these traversals would have been tough if I couldn't distinguish between in and out
    edges.

    Right now, I have a version which actually finishes, which is something I guess. The answer it gives, however, is not
    correct. As I was going to sleep last night I had a thought - my current version probably reports a lot of duplicate
    paths, since it runs the whole traversal for each of the possible caves you visit twice.

    It would probably be easier to evaluate the cause of the issue if not for the giant mess of nested lists that the current
    solution spits out. Last night, I played around with a few different ideas involving flat_map and foldl to try to flatten the
    list of lists while leaving each actual path intact, but I think they're flattening too blindly, because I kept winding
    up with actual path elements mixed into the list.

    Current game plan is this - let's run the part 2 code against the small input in the puzzle, and see what comes out.
    If there are a bunch of duplicate paths, we can try figure out how to flatten the output and uniq it. If that works
    then we can call it a day.

    If not, we may have a problem with the part of paths that evaluates valid new paths - I was struggling to get that
    conditional right last night. One way to fix that problem may be to intelligently delete edges from the graph as we
    walk down the list of paths. This should be fine to do since every recursive call gets its own copy (yay immutability!),
    and would likely simplify the logic of paths somewhat. However, I think this version would still have the issue
    with deeply nested output, so lets try to fix that first.

    ===
    We've got it! Hail Santa!
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
    Given a graph, and a starting vertex, and a cave you're allowed to visit twice, enumerates the paths from the start vertex to
    "end". Returns a nested list that you need to flatten.
    """
    def paths_part1(graph) do
      paths(graph, "start", "")
      |> flatten_to_list_of_lists()
    end

    @doc """
    This version goes through all the possible small caves you can visit twice.
    """
    def paths_part2(graph) do
      Graph.vertices(graph)
      |> Enum.filter(fn v ->
        v != "start" and v != "end" and is_small_cave?(v)
      end)
      |> Enum.map(fn small_cave ->
        paths(graph, "start", small_cave)
      end)
      |> flatten_to_list_of_lists()
      |> Enum.uniq()
    end

    def paths(graph, current_v, small_cave_you_can_visit_twice, visited \\ []) # yuck, i don't like this
    def paths(_graph, "end", _small_cave_you_can_visit_twice, visited) do
      visited ++ ["end"]
    end

    def paths(graph, current_v, small_cave_you_can_visit_twice, visited) do
      new_visited = visited ++ [current_v]
      times_visited_the_small_cave_you_can_visit_twice = Enum.count(visited, &(&1 == small_cave_you_can_visit_twice))

      out_edges =
        Graph.out_edges(graph, current_v)
        |> Enum.reject(fn %{v2: next_v} ->
          (next_v == small_cave_you_can_visit_twice and times_visited_the_small_cave_you_can_visit_twice == 2)
          or (next_v in visited and is_small_cave?(next_v) and not (next_v == small_cave_you_can_visit_twice))
        end)

      if Enum.empty?(out_edges) do
        []
      else
        Enum.map(out_edges, fn %{v2: next_v} ->
          paths(graph, next_v, small_cave_you_can_visit_twice, new_visited)
        end)
      end
    end

    @doc """
    Given a big ol jumble of lists of lists of lists, whips them boys into shape and returns a nice orderly list
    containing only the lists that weren't deeply nested.
    """
    def flatten_to_list_of_lists(nested_list) do
      flatten_to_list_of_lists(nested_list, [])
      |> Enum.reject(&Enum.empty?/1)
    end

    def flatten_to_list_of_lists(nested_list, nice_list) do
      current_nice_lists =
        Enum.filter(nested_list, &is_nice_list?/1)
      new_nice_lists = nice_list ++ current_nice_lists

      naughty_lists = # lists which have nested lists, name is cryptic but, well... ho ho ho!
        Enum.reject(nested_list, &is_nice_list?/1)

      if Enum.empty?(naughty_lists) do
        new_nice_lists
      else
        flatten_to_list_of_lists(flatten_outer_list(naughty_lists), new_nice_lists)
      end
    end

    @doc """
    True if the list does not contain any inner lists.
    """
    def is_nice_list?(list) do
      Enum.all?(list, fn element -> not is_list(element) end)
    end

    @doc """
    Removes the outer layer of nesting from a deeply nested list.
    """
    def flatten_outer_list(list) do
      List.foldl(list, [], &(&1 ++ &2))
    end

    def part_1(input) do
      input
      |> input_to_graph()
      |> paths_part1()
      |> Enum.count()
    end

    def part_2(input) do
      input
      |> input_to_graph()
      |> paths_part2()
      |> Enum.count()
    end
  end
