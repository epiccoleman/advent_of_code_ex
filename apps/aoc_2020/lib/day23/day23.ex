  defmodule Day23 do
    def start_state_from_input(input) do
      cups = Integer.digits(input)
      %{
        cups: cups,
        current_cup: Enum.at(cups, 0)
      }
    end
    def do_a_move(%{cups: cups, current_cup: current_cup}, max \\ 9) do
      # pick up the three cups clockwise of current
      {held_cups, cup_circle} = take_three_cups(cups, current_cup)

      # pick a destination cup - current_cup - 1 unless that's not in held

      destination_cup = current_cup - 1
      final_destination = if destination_cup not in cup_circle do
        # pick new one by subtracting 1 until its valid
        Enum.reduce_while(1..100_000_000, destination_cup, fn _i, acc ->
          cond do
            acc < 1 -> {:cont, max}
            acc not in held_cups -> {:halt, acc}
            true -> {:cont, acc - 1}
          end
        end)
      else
        destination_cup
      end

      new_cups = insert_cups_at_destination(cup_circle, held_cups, final_destination)
      new_current = next_current_cup(new_cups, current_cup)

      ret = %{
        cups: new_cups,
        current_cup: new_current,
        last_dest: final_destination
      }
      # IO.inspect(ret)
      ret
    end

    def next_current_cup(cups, current_cup) do
      rotated = rotate_current_cup_to_front(cups, current_cup)
      Enum.at(rotated, 1)
    end

    def insert_cups_at_destination(cup_circle, held_cups, destination) do
      [front | rest] = rotate_current_cup_to_front(cup_circle, destination)
      [front] ++ held_cups ++ rest
    end


    def take_three_cups(cups, current_cup) do
      rotated = rotate_current_cup_to_front(cups, current_cup)
      get_slice_and_rest(rotated, 1, 3)
    end

    def rotate_current_cup_to_front([front_cup | _rest] = cups, current_cup) do
      if front_cup == current_cup do
        cups
      else
        rotations = get_index_of_cup(cups, current_cup) - 1

        Enum.reduce(0..rotations, cups, fn _i, acc ->
          rotate_list(acc)
        end)
      end
    end

    def rotate_list([front | rest]) do
      rest ++ [front]
    end

    def get_slice_and_rest(list, index, count) do
      slice = Enum.slice(list, index, count)

      rest = Enum.reduce(1..count, list, fn _i, acc ->
        List.delete_at(acc, index)
      end)

      {slice,rest}
    end

    def get_index_of_cup(cups, cup_num) do
      Enum.find_index(cups, &(&1 == cup_num))
    end

    def play_crab_cups(input, move_count) do
      start = start_state_from_input(input)

      Enum.reduce(1..move_count, start, fn _i, acc ->
        do_a_move(acc)
      end)
    end

    def insert_cups_at_index(cup_circle, held_cups, index) do
      cup_circle
      |> List.insert_at(index, Enum.at(held_cups, 0))
      |> List.insert_at(index + 1, Enum.at(held_cups, 1))
      |> List.insert_at(index + 2, Enum.at(held_cups, 2))
    end

    ######################


    def start_state_from_input_2(input) do
      #instead of an array we're gonna try a map where map[cup] == next cup

      list = Integer.digits(input) ++ Enum.to_list(10..1000000)

      cups = make_map_list(list)

      %{ cups: cups, current_cup: List.first(list)}
    end

    def make_map_list(list) do
      chunks =
        Enum.chunk_every(list, 2, 1, :discard)

      chunks
      |> List.insert_at(length(chunks) - 1, [List.last(list), List.first(list)])
      |> Enum.into(%{}, fn [a,b] -> {a,b} end)
    end

    def take_three_cups_2(cups, current_cup) do
      cup1 = cups[current_cup]
      cup2 = cups[cup1]
      cup3 = cups[cup2]

      cup4 = cups[cup3]

      new_cups =
        Map.delete(cups, cup1)
        |> Map.delete(cup2)
        |> Map.delete(cup3)
        |> Map.put(current_cup, cup4)
      held = [cup1, cup2, cup3]

      {held, new_cups}
    end

    def insert_cups(cups, [cup1, cup2, cup3], destination_cup) do
      cup4 = Map.get(cups, destination_cup)

      cups
      |> Map.put(destination_cup, cup1)
      |> Map.put(cup1, cup2)
      |> Map.put(cup2, cup3)
      |> Map.put(cup3, cup4)
    end

    def choose_destination_cup(cups, current_cup) do
       maybe = current_cup - 1

       if Map.has_key?(cups, maybe) do
        maybe
       else
        choose_destination_cup(cups, maybe)
       end
    end

    def print_state(%{cups: cups, current_cup: current_cup}) do
      first = Map.get(cups, current_cup)
      Enum.reduce(0..Enum.count(cups), %{output: "#{first}", target: first}, fn _i, %{output: out_str, target: target} = acc ->
        if target == current_cup do
          acc
        else
          next = Map.get(cups, target)
          output = out_str <> " #{next}"
          %{output: output, target: next}
        end
      end)
    end

    def do_a_move_2(%{cups: cups, current_cup: current_cup}) do
      # pick up the three cups clockwise of current
      max = Enum.count(cups)
      {held_cups, cup_circle} = take_three_cups_2(cups, current_cup)

      # pick a destination cup - current_cup - 1 unless that's not in held

      destination_cup = current_cup - 1
      final_destination = if (destination_cup in held_cups) or destination_cup < 1 do
        # pick new one by subtracting 1 until its valid
        Enum.reduce_while(1..10_000_000, destination_cup, fn _i, acc ->
          cond do
            acc < 1 -> {:cont, max}
            acc not in held_cups -> {:halt, acc}
            true -> {:cont, acc - 1}
          end
        end)
      else
        destination_cup
      end


      ## now we have a list and a destination cup

      new_cups = insert_cups(cup_circle, held_cups, final_destination)
      new_current = Map.get(new_cups, current_cup)

      ret = %{
        cups: new_cups,
        current_cup: new_current,
        last_dest: final_destination
      }
      # IO.inspect(ret)
      ret
    end
    def play_crab_cups_2(start, move_count) do

      # start = start_state_from_input_2(input)

      Enum.reduce(1..move_count, start, fn _i, state ->
        # IO.puts(i)

        do_a_move_2(state)
      end)
    end

    def part_1(input) do
      %{cups: cups} = play_crab_cups(input, 100)
      [_ | num ] = rotate_current_cup_to_front(cups, 1)
      Integer.undigits(num)
    end

    def part_2(input) do
      start = start_state_from_input_2(input)
      %{cups: cups} = play_crab_cups_2(start, 10_000_000)

      # one_i = get_index_of_cup(cups, 1)
      a = Map.get(cups, 1)
      b = Map.get(cups, a)
      a*b
    end
  end
