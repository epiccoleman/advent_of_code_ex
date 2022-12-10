defmodule Aoc2022.Day06 do
  def find_first_packet_marker(input, packet_marker_length) do
    index =
      input
      |> String.graphemes()
      |> Enum.chunk_every(packet_marker_length, 1, :discard)
      |> Enum.find_index(fn chunk ->
        MapSet.size(MapSet.new(chunk)) == length(chunk)
      end)

    index + packet_marker_length
  end

  def part_1(input) do
    input
    |> find_first_packet_marker(4)

  end

  def part_2(input) do
    input
    |> find_first_packet_marker(14)
  end
end
