defmodule Day25 do

  def transform_subject(subject, loop_size, value \\ 1) do
    if loop_size < 1 do
      value
    else
      new_value = rem(value * subject, 20201227) # i bet this number is significant somehow
      new_loop_size = loop_size - 1
      transform_subject(subject, new_loop_size, new_value)
    end
  end

  def find_loop_size(target, subject \\ 7) do
    Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), 1, fn i, v ->
      check_num = rem(v * subject, 20201227)
      if check_num == target do
        {:halt, i}
      else
        {:cont, check_num}
      end
    end)
  end

  def part_1([pk_a, pk_b]) do
    loop_size = find_loop_size(pk_a)

    transform_subject(pk_b, loop_size)
  end

  def part_2(_input) do
    true
    # merry christmas!
  end
end
