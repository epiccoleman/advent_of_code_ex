  defmodule Aoc2021.Day06 do
    @moduledoc """
    --- Day 6: Lanternfish ---

    The sea floor is getting steeper. Maybe the sleigh keys got carried this way?

    A massive school of glowing lanternfish swims past. They must spawn quickly to reach such large numbers - maybe exponentially quickly? You should model their growth rate to be sure.

    Although you know nothing about this specific species of lanternfish, you make some guesses about their attributes. Surely, each lanternfish creates a new lanternfish once every 7 days.

    However, this process isn't necessarily synchronized between every lanternfish - one lanternfish might have 2 days left until it creates another lanternfish, while another might have 4. So, you can model each fish as a single number that represents the number of days until it creates a new lanternfish.

    Furthermore, you reason, a new lanternfish would surely need slightly longer before it's capable of producing more lanternfish: two more days for its first cycle.

    So, suppose you have a lanternfish with an internal timer value of 3:

        After one day, its internal timer would become 2.
        After another day, its internal timer would become 1.
        After another day, its internal timer would become 0.
        After another day, its internal timer would reset to 6, and it would create a new lanternfish with an internal timer of 8.
        After another day, the first lanternfish would have an internal timer of 5, and the second lanternfish would have an internal timer of 7.

    A lanternfish that creates a new fish resets its timer to 6, not 7 (because 0 is included as a valid timer value). The new lanternfish starts with an internal timer of 8 and does not start counting down until the next day.

    Realizing what you're trying to do, the submarine automatically produces a list of the ages of several hundred nearby lanternfish (your puzzle input). For example, suppose you were given the following list:

    3,4,3,1,2

    This list means that the first fish has an internal timer of 3, the second fish has an internal timer of 4, and so on until the fifth fish, which has an internal timer of 2. Simulating these fish over several days would proceed as follows:

    Initial state: 3,4,3,1,2
    After  1 day:  2,3,2,0,1
    After  2 days: 1,2,1,6,0,8
    After  3 days: 0,1,0,5,6,7,8
    After  4 days: 6,0,6,4,5,6,7,8,8
    After  5 days: 5,6,5,3,4,5,6,7,7,8
    After  6 days: 4,5,4,2,3,4,5,6,6,7
    After  7 days: 3,4,3,1,2,3,4,5,5,6
    After  8 days: 2,3,2,0,1,2,3,4,4,5
    After  9 days: 1,2,1,6,0,1,2,3,3,4,8
    After 10 days: 0,1,0,5,6,0,1,2,2,3,7,8
    After 11 days: 6,0,6,4,5,6,0,1,1,2,6,7,8,8,8
    After 12 days: 5,6,5,3,4,5,6,0,0,1,5,6,7,7,7,8,8
    After 13 days: 4,5,4,2,3,4,5,6,6,0,4,5,6,6,6,7,7,8,8
    After 14 days: 3,4,3,1,2,3,4,5,5,6,3,4,5,5,5,6,6,7,7,8
    After 15 days: 2,3,2,0,1,2,3,4,4,5,2,3,4,4,4,5,5,6,6,7
    After 16 days: 1,2,1,6,0,1,2,3,3,4,1,2,3,3,3,4,4,5,5,6,8
    After 17 days: 0,1,0,5,6,0,1,2,2,3,0,1,2,2,2,3,3,4,4,5,7,8
    After 18 days: 6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8

    Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, while each other number decreases by 1 if it was present at the start of the day.

    In this example, after 18 days, there are a total of 26 fish. After 80 days, there would be a total of 5934.

    Find a way to simulate lanternfish. How many lanternfish would there be after 80 days?

    --- Part Two ---

    Suppose the lanternfish live forever and have unlimited food and space. Would they take over the entire ocean?

    After 256 days in the example above, there would be a total of 26984457539 lanternfish!

    How many lanternfish would there be after 256 days?

    ==================================

    My notes:

    So this is obviously one of those where for the first input it will be manageable naively but then he'll ask me to calculate
    how many lanternfish there will be in a million days or something.

    This is an exponential growth problem, so there must be a way to express this as math instead of actually simulating the growth.any()

    For funsies, I'll write it naively for the first one, and then we can see where we end up. But what I'm thinking on the math bit
    is that there should be a way to figure out, for any given starting number, how many fish will be produced after `t` days.

    If you have that, you just run it on each of the starting inputs, and there you go.

    the exponential growth model $$y = a(1 + r)^t$$ ,
    where a is the initial amount, the base (1 + r) is the growth factor, r is the growth rate, and t is the time interval.

    That's from a quick google for "model exponential growth" - not sure how to apply it here yet.

    Ok well... what about the easiest case? a fish with zero days. because simulating anything else should just basically
    be minusing its count from t and then running this simulation

    so one option that's not super math could be developing a 'zero' fish simulator that takes a t and then you could use that

    also we could memoize out a table if needed

    we can also solve for a growth rate but we'd probably have to simulate for a while to get accurate data
    i'm sure there's a way to get it from the numbers given but ... idk how

    t = -1 | f = 1
    t = 0  | f = 2 (one 6, one 8)
    t = 6  | f = 3
    t = 8  | f = 4 (two 6s, two 8s)
    t = 14 | f = 6 (two 6s, two 2s, and two 8s)
    t = 16 | f = 8 (two 4s, four 6s, two 8s)
    t = 20 | f = 10 (two 6s, two 2s, four 4s, two 8s)
    t = 22 | f = 12 (two 4s, four 6s, four 2s, two 8s)
    t = 24 | f = 20 (two 2s, four 4s, six 6s, four 8s)

    OK well, as expected, the naive approach slows to a crawl around 150 iterations, so we're going to have
    to come up with something better.
    """

    @doc "awwww yeah"
    # neat idea to use the deprecation thing but it makes warnings for tests that don't matter, so we'll leave it alone
    #@deprecated "Use simulate_lanternfish_reproduction_smart instead"
    def simulate_lanternfish_reproduction(fish_list, n_days) do
    #Each day, a 0 becomes a 6 and adds a new 8 to the end of the list,
    #while each other number decreases by 1 if it was present at the start of the day.
      Enum.reduce(1..n_days, fish_list, fn _n, fish_list ->
        fish_list
        |> Enum.map(fn fish_num ->
          if fish_num == 0 do
            [8, 6]
          else
            fish_num - 1
          end
        end)
        |> List.flatten()
      end)
    end

    def simulate_lanternfish_reproduction_smart(fish_list, t) do
      fish_counts = AocUtils.MiscUtils.count_list_elements(fish_list)

      # gotta make sure that all the numbers are initialized, otherwise you get math errors.
      # probably a cleverer way to do it but this will do
      fish_counts = Enum.reduce(0..8, fish_counts, fn n, fish_counts ->
        if Map.has_key?(fish_counts, n) do
          fish_counts
        else
          Map.put(fish_counts, n, 0)
        end
      end)

      Enum.reduce(1..t, fish_counts, fn _t, old_counts ->
       new_sixes = old_counts[0] # fish that will have reproduced this turn, and reset their state to 6
       new_eights = old_counts[0] # new fish born from the previous fish (same number as the number of fish who were ready to reproduce)

       # you get the number of fish in each state by simply rotating them through. i.e. any fish that was a 6 is now a 5, etc.
       # then you also need to account for fish that newly became 6s (because they reproduced)
       # and any fish that were born this round become the new 8s
       %{
        0 => old_counts[1],
        1 => old_counts[2],
        2 => old_counts[3],
        3 => old_counts[4],
        4 => old_counts[5],
        5 => old_counts[6],
        6 => old_counts[7] + new_sixes,
        7 => old_counts[8],
        8 => new_eights
       }
      end)
    end

    def part_1(input) do
      input
      |> simulate_lanternfish_reproduction_smart(80)
      |> Map.values()
      |> Enum.sum()
    end

    def part_2(input) do
      input
      |> simulate_lanternfish_reproduction_smart(256)
      |> Map.values()
      |> Enum.sum()
    end
  end
