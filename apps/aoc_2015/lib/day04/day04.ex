  defmodule Day04 do
    def part_1(input) do
      Enum.reduce_while(Stream.iterate(0, &(&1 + 1)), 0, fn i, _acc ->
        hash = :crypto.hash(:md5, "#{input}#{i}") |> Base.encode16()

        if Regex.match?(~r<^00000>, hash) do
          {:halt, i}
        else
          {:cont, i}
        end
      end)
    end

    def part_2(input) do
      Enum.reduce_while(Stream.iterate(0, &(&1 + 1)), 0, fn i, _acc ->
        if rem(i, 1000000) == 0 do IO.puts(i) end
        hash = :crypto.hash(:md5, "#{input}#{i}") |> Base.encode16()

        if Regex.match?(~r<^000000>, hash) do
          {:halt, i}
        else
          {:cont, i}
        end
      end)
    end
  end
