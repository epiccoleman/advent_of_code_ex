defmodule Day13 do
  def process_input_part_1(input) do
    earliest_time =
      input
      |> List.first()
      |> String.to_integer()

    timestamps =
      input
      |> List.last()
      |> String.split(",")
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer/1)

    {earliest_time, timestamps}
  end

  def closest_departure_time(timestamp, target_time) do
    factor = (target_time / timestamp) |> Float.ceil()
    timestamp * factor
  end

  def get_id_offset_pairs(input) do
    for i <- 0..(length(input) - 1) do
      id = Enum.at(input, i)

      if id == "x" do
        nil
      else
        {String.to_integer(id), i}
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  def test_timestamp(id_offset_pairs, t) do
    id_offset_pairs
    |> Enum.map(fn {id, offset} ->
      is_divisible?(t + offset, id)
    end)
    |> Enum.all?()
  end

  def is_divisible?(a, b), do: rem(a, b) == 0

  def part_1(input) do
    {earliest, timestamps} = process_input_part_1(input)

    {id, _, wait} =
      timestamps
      |> Enum.map(fn timestamp ->
        id = timestamp
        closest = closest_departure_time(timestamp, earliest)
        wait_time = closest - earliest

        {id, closest, wait_time}
      end)
      |> Enum.min_by(fn {_, _, wait_a} ->
        wait_a
      end)

    id * wait
  end

  def part_2(input, start_val \\ 100_000_000_000_004) do
    # start_val = 100000000000004
    # the first number bigger than 100000000000000 that is divisible by 41
    # found via: 100000000000000..100000000000041 |> Enum.find( fn n -> Day13.is_divisible?(n, 41) end)
    first_id = input |> String.split(",") |> List.first() |> String.to_integer()

    pairs =
      input
      |> String.split(",")
      |> get_id_offset_pairs()

    almost =
      Stream.iterate(start_val, &(&1 + first_id))
      |> Enum.take_while(fn t -> not test_timestamp(pairs, t) end)
      |> List.last()

    almost + first_id
  end

  def part_2_smart(input) do
    first_id = input |> String.split(",") |> List.first() |> String.to_integer()

    pairs =
      input
      |> String.split(",")
      |> get_id_offset_pairs()

    do_thing(pairs, first_id, 0)
  end

  def do_thing(pairs, step_size, start_t) do
    if Enum.empty?(pairs) or length(pairs) <= 1 do
      start_t
    else
      {id_b, offset_b} = pairs |> Enum.at(1)

      almost =
        Stream.iterate(start_t, &(&1 + step_size))
        |> Enum.take_while(fn t -> not is_divisible?(t + offset_b, id_b) end)
        |> List.last()

      the_t_you_were_looking_for =
        if almost == nil do
          start_t
        else
          almost + step_size
        end

      [_ | rest] = pairs

      do_thing(rest, step_size * id_b, the_t_you_were_looking_for)
    end
  end
end

# find the first number where you can divide the first two
# the next number must be some multiple of that
