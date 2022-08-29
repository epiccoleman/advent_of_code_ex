defmodule Aoc2021.Day07 do
  @moduledoc """
  --- Day 7: The Treachery of Whales ---

  A giant whale has decided your submarine is its next meal, and it's much faster than you are. There's nowhere to run!

  Suddenly, a swarm of crabs (each in its own tiny submarine - it's too deep for them otherwise) zooms in to rescue you! They seem to be preparing to blast a hole in the ocean floor; sensors indicate a massive underground cave system just beyond where they're aiming!

  The crab submarines all need to be aligned before they'll have enough power to blast a large enough hole for your submarine to get through. However, it doesn't look like they'll be aligned before the whale catches you! Maybe you can help?

  There's one major catch - crab submarines can only move horizontally.

  You quickly make a list of the horizontal position of each crab (your puzzle input). Crab submarines have limited fuel, so you need to find a way to make all of their horizontal positions match while requiring them to spend as little fuel as possible.

  For example, consider the following horizontal positions:

  16,1,2,0,4,2,7,1,2,14

  This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

  Each change of 1 step in horizontal position of a single crab costs 1 fuel. You could choose any horizontal position to align them all on, but the one that costs the least fuel is horizontal position 2:

      Move from 16 to 2: 14 fuel
      Move from 1 to 2: 1 fuel
      Move from 2 to 2: 0 fuel
      Move from 0 to 2: 2 fuel
      Move from 4 to 2: 2 fuel
      Move from 2 to 2: 0 fuel
      Move from 7 to 2: 5 fuel
      Move from 1 to 2: 1 fuel
      Move from 2 to 2: 0 fuel
      Move from 14 to 2: 12 fuel

  This costs a total of 37 fuel. This is the cheapest possible outcome; more expensive outcomes include aligning at position 1 (41 fuel), position 3 (39 fuel), or position 10 (71 fuel).

  Determine the horizontal position that the crabs can align to using the least fuel possible. How much fuel must they spend to align to that position?

  --- Part Two ---

  The crabs don't seem interested in your proposed solution. Perhaps you misunderstand crab engineering?

  As it turns out, crab submarine engines don't burn fuel at a constant rate. Instead, each change of 1 step in horizontal position costs 1 more unit of fuel than the last: the first step costs 1, the second step costs 2, the third step costs 3, and so on.

  As each crab moves, moving further becomes more expensive. This changes the best horizontal position to align them all on; in the example above, this becomes 5:

      Move from 16 to 5: 66 fuel
      Move from 1 to 5: 10 fuel
      Move from 2 to 5: 6 fuel
      Move from 0 to 5: 15 fuel
      Move from 4 to 5: 1 fuel
      Move from 2 to 5: 6 fuel
      Move from 7 to 5: 3 fuel
      Move from 1 to 5: 10 fuel
      Move from 2 to 5: 6 fuel
      Move from 14 to 5: 45 fuel

  This costs a total of 168 fuel. This is the new cheapest possible outcome; the old alignment position (2) now costs 206 fuel instead.

  Determine the horizontal position that the crabs can align to using the least fuel possible so they can make you an escape route! How much fuel must they spend to align to that position?

  ================

  My notes:

  This seems straightforward enough if we just do it bruteforce style - i.e. for every possible position, calculate the fuel
  cost for each crab to move there, sum it, and then pick the position with the lowest fuel cost.

  There are 1000 crabs in the list with positions ranging from around ~0 to ~2000 which means we'll have to calculate fuel
  cost for 1000 crabs for around 2000 positions - so something like 2,000,000 million calculations. However, the calculation
  for each crab is just a single subtraction and `abs` call, so I don't think it'll be too onerous - a modern macbook should be
  able to run 200000 subtractions pretty friggin' quick.

  If it turns out that this is too slow, we could try to come up with a more clever approach to picking potential positions. It
  occurs to me that the average of all the positions is probably close to the right answer?

  Yeah, plenty fast. Also, best pos was 342, whereas the average was about 479, so guess I was wrong on that idea.

  For part 2, I just googled "factorial but addition," and learned that this concept is known as a "triangular number".
  The formula for calculating a triangular number for n is: (n^2 + n) / 2.
  https://math.stackexchange.com/questions/60578/what-is-the-term-for-a-factorial-type-operation-but-with-summation-instead-of-p

  Originally the simulate positions function returned the best position along with the fuel cost, but since the
  puzzle didn't ask for this it made the code a little simpler to just remove it.
  """


  def calculate_fuel_cost_for_target_position_part_1(crab_positions, target_pos) do
    crab_positions
    |> Enum.map(fn crab_start_pos -> abs(crab_start_pos - target_pos) end)
    |> Enum.sum()
  end

  def calculate_fuel_cost_for_target_position_part_2(crab_positions, target_pos) do
    crab_positions
    |> Enum.map(fn crab_start_pos ->
      distance = abs(crab_start_pos - target_pos)

      # see link in moduledoc for background on this calculation
      # it simplifies to (n^2 + 1) / 2, but n (n+1) / 2 is easier to write
      (distance * (distance + 1)) / 2
    end)
    |> Enum.sum()
  end

  def simulate_possible_positions(crab_positions, cost_fn) do
    min_pos = Enum.min(crab_positions)
    max_pos = Enum.max(crab_positions)

    Enum.map(min_pos..max_pos, fn target_pos ->
      cost_fn.(crab_positions, target_pos)
    end)
  end

  def part_1(input) do
    input
    |> simulate_possible_positions(&calculate_fuel_cost_for_target_position_part_1/2)
    |> Enum.min()
  end

  def part_2(input) do
    fuel_cost =
      input
      |> simulate_possible_positions(&calculate_fuel_cost_for_target_position_part_2/2)
      |> Enum.min()

    # comes back as a float due to the division in part 2 calc, trunc fixes that
    trunc(fuel_cost)
  end
end
