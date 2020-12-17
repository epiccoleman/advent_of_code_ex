  defmodule Day16 do

    def process_input_data(input) do
      [constraints_str, my_ticket_str, nearby_tickets_str] =
        input |> String.split("\n\n")

      my_ticket =
        my_ticket_str
        |> String.split("\n")
        |> Enum.at(1)
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      nearby_tickets =
        nearby_tickets_str
        |> String.split("\n")
        |> Enum.drop(1)
        |> Enum.map(fn ticket_str -> String.split(ticket_str, ",") end)
        |> Enum.map(fn ticket_str_list ->
          Enum.map(ticket_str_list, &String.to_integer/1)
        end)

      constraints =
        constraints_str
        |> String.split("\n")
        |> Enum.map(&(String.split(&1, ": ")))
        |> Enum.map(fn [field_name_str, ranges_str] ->
          ranges =
            ranges_str
            |> String.split(" or ")
            |> Enum.map(fn range_str ->
              String.split(range_str, "-")
            end)
            |> Enum.map(fn range_list ->
              [ range_a, range_b ] =
                range_list
                |> Enum.map(&String.to_integer/1)

              range_a..range_b
            end)
          {field_name_str, ranges}
        end)
        |> Enum.into(%{})

        %{
          constraints: constraints,
          my_ticket: my_ticket,
          nearby_tickets: nearby_tickets
        }
    end

    def discard_bad_tickets(%{nearby_tickets: nearby_tickets} = data) do
      all_constraints = list_all_constraints(data)
      new_nearby_tickets =
        nearby_tickets
        |> Enum.filter(fn ticket_vals ->
          not Enum.any?(ticket_vals, fn val -> not valid_in_any_field?(val, all_constraints) end)
        end)

      Map.put(data, :nearby_tickets, new_nearby_tickets)
    end

    def valid_in_any_field?(n, constraints) do
      range_checks = Enum.map(constraints, fn range ->
        Enum.member?(range, n)
      end)

      not Enum.all?(range_checks, &(not &1))
    end

    def list_all_constraints(data) do
      data.constraints
      |> Enum.reduce([], fn {_class, list}, acc ->
        acc ++ list
      end)
    end

    def part_1(input) do
      data = process_input_data(input)

      all_constraints = list_all_constraints(data)

      all_ticket_fields =
        data.nearby_tickets
        |> Enum.flat_map(&(&1))

      invalid_values =
        all_ticket_fields
        |> Enum.map(fn value ->
          if not valid_in_any_field?(value, all_constraints) do
            value
          else
            0
          end
        end)

      invalid_values |> Enum.sum()
    end

    def possible_field_names(n, constraints) do
      constraints
      |> Enum.map(fn {field_name, ranges} ->
        if Enum.any?(ranges, &(n in &1)) do
          field_name
        end
      end )
      |> Enum.reject(&is_nil/1)
    end

    def get_possibles(data) do
      all_constraints =
        data.constraints
        |> Map.keys()
        |> MapSet.new()

      for i <- 0..length(data.my_ticket)-1 do
        all_vals_at_this_index =
          data.nearby_tickets
          |> Enum.map(&(Enum.at(&1, i)))

        possible = all_vals_at_this_index
        |> Enum.map(&(possible_field_names(&1, data.constraints)))
        |> Enum.map(&MapSet.new/1)
        |> Enum.reduce(all_constraints, fn set, acc ->
          MapSet.intersection(acc, set)
        end)

        {i, possible}
      end
      |> Enum.into(%{})
    end

    def remove_option(possibles, field_name) do
      possibles
      |> Enum.map(fn {i, set} ->
        {i,
         MapSet.delete(set, field_name)
        }
      end)
    end

    # def process_of_elimination(possibles) do
      # idk, i did it manually

    # 0: zone
    # 6: arrival station
    # 12: row
    # 10: route
    # 8: price
    # 3: train
    # 1: departure time
    # 13: departure_location
    # 5: departure track
    # 2: departure platform
    # 15: departure date
    # 19: departure station
    # 9: wagon
    # 7: seat
    # 14: class
    # 4: arrival track
    # 18: duration
    # 17: arrival platform
    # 16: arrival location
    # 11: type
    # end

    def part_2(input) do
      data =
        input
        |> process_input_data
        |> discard_bad_tickets

      # possibles = get_possibles(data)
          # 1: departure time
          # 13: departure_location
          # 5: departure track
          # 2: departure platform
          # 15: departure date
          # 19: departure station

      Enum.at(data.my_ticket, 1)
      * Enum.at(data.my_ticket, 13)
      * Enum.at(data.my_ticket, 5)
      * Enum.at(data.my_ticket, 2)
      * Enum.at(data.my_ticket, 15)
      * Enum.at(data.my_ticket, 19)

    end
  end
