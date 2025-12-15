defmodule Aoc2025.Day01 do
  @lock_clicks 100

  @doc """
  Given a start position and a rotation, perform the rotation, returning
  the resulting position
  """
  def rotate(start_pos, rotation_str) do
    {direction, num_str} = String.split_at(rotation_str, 1)

    num = String.to_integer(num_str)

    op = case direction do
      "L" ->
        &-/2
      "R" ->
        &+/2
    end

    op.(start_pos, num) |> Integer.mod(@lock_clicks)
  end

  def part_1(input) do
    input
    |> Enum.reduce(%{count: 0, pos: 50}, fn rotation, %{count: count, pos: pos} ->
      new_pos = rotate(pos, rotation)
      new_count = if new_pos == 0 , do: count + 1, else: count
      %{pos: new_pos, count: new_count}
    end )
    |> Map.get(:count)
  end

  @doc """
  Performs the same rotation as rotate/1, but returns the number of times the
  rotation ends up passing 0 as well as the new position.

  Returns a tuple with {new_position, times_passed_zero}
  """
  def rotate_with_click_count(start_pos, rotation_str) do
    {direction, num_str} = String.split_at(rotation_str, 1)

    num = String.to_integer(num_str)

    op = case direction do
      "L" ->
        &-/2
      "R" ->
        &+/2
    end

    # total = op.(start_pos, num)

    # new_pos = Integer.mod(total, @lock_clicks)

    # this took me a little thinking to figure out. initially i landed
    # on "the total minus the remainder (new_pos in this case) divided by the
    # modulus (100 in this case) should be the number of times zero was passed

    # then i realized floor division should do the same thing. in Elixir
    # this means using either Kernel.div or Integer.floor_div. the distinction is that
    # Kernel.div will always round toward zero (which means you roun)


    # times_passed_zero_naive = abs(Integer.floor_div(total, @lock_clicks)) #+ (if total < 0, do: 1, else: 0)
    # times_passed_zero = cond do

    #   new_pos == 0 and times_passed_zero_naive == 1 -> 0
    #   total < 0 -> times_passed_zero_naive + 1
    #   start_pos == 0 and total < 0 -> times_passed_zero_naive - 1
    #   true ->
    #     times_passed_zero_naive

    # {new_pos, times_passed_zero_naive}

    #   end

    # argh. fuck it, loop

    %{ current: new_pos, count: count   } = Enum.reduce(1..num, %{current: start_pos, count: 0},
      fn _, %{current: current, count: count}  ->
      proposed_next_pos = op.(current, 1)

      next_pos = cond do
        proposed_next_pos > 99 -> 0
        proposed_next_pos < 0 -> 99
        true -> proposed_next_pos
      end

      new_count = if next_pos == 0, do: count + 1, else: count

      %{
        last: current,
        current: next_pos,
        count: new_count
      }
    end)

    {new_pos, count}
  end

  def part_2(input) do
    input
    |> Enum.reduce(%{count: 0, pos: 50}, fn rotation, %{count: count, pos: pos} ->
      {new_pos, times_passed_zero} = rotate_with_click_count(pos, rotation)
      %{pos: new_pos, count: count + times_passed_zero}
    end )
    |> Map.get(:count)
  end
end
