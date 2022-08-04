  defmodule Aoc2021.Day11 do
    @moduledoc """
    You enter a large cavern full of rare bioluminescent dumbo octopuses! They seem to not like the Christmas lights on your submarine, so you turn them off for now.

    There are 100 octopuses arranged neatly in a 10 by 10 grid. Each octopus slowly gains energy over time and flashes brightly for a moment when its energy is full. Although your lights are off, maybe you could navigate through the cave without disturbing the octopuses if you could predict when the flashes of light will happen.

    Each octopus has an energy level - your submarine can remotely measure the energy level of each octopus (your puzzle input). For example:

    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526

    The energy level of each octopus is a value between 0 and 9. Here, the top-left octopus has an energy level of 5, the bottom-right one has an energy level of 6, and so on.

    You can model the energy levels and flashes of light in steps. During a single step, the following occurs:

    First, the energy level of each octopus increases by 1.
    Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1, including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than 9, it also flashes. This process continues as long as new octopuses keep having their energy level increased beyond 9. (An octopus can only flash at most once per step.)
    Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.

    --- Part Two ---
    It seems like the individual flashes aren't bright enough to navigate. However, you might have a better option: the flashes seem to be synchronizing!

    If you can calculate the exact moments when the octopuses will all flash simultaneously, you should be able to navigate through the cavern. What is the first step during which all octopuses flash?
    """
    alias AocUtils.Grid2D
    @doc """
    Receives input as a list of input lines. Converts them to a Grid2D, where each value holds a map of the octopus's
    energy level and whether or not it has flashed on this turn.
    """
    def input_to_grid(input) do
      input
      |> Enum.map(fn line_str ->
        line_str
        |> String.graphemes()
        |> Enum.map(fn energy_str ->
          %{energy: String.to_integer(energy_str),
            flashed?: false }
          end)
      end)
      |> Grid2D.new()
    end

    def simulate_flashes(grid) do
      # get a list of everyone who will flash
      flashers = Enum.filter(grid, fn {_pos, %{energy: energy, flashed?: flashed?}} ->
        energy > 9 and not flashed?
      end)

      done_flashing? = Enum.empty?(flashers)

      if done_flashing? do
        grid
      else
        # get the neighbors of each of those cells, and count how many flashes they'll receive
        flash_counts =
          Enum.flat_map(flashers, fn {pos, _cell_state} ->
            Grid2D.neighbor_locs(grid, pos)
          end)
          |> AocUtils.MiscUtils.count_list_elements()

        # update the energy levels of every neighbor who receives flashes
        grid_after_flashes =
          Enum.reduce(flash_counts, grid, fn {flash_pos, flash_count}, grid_acc ->
            Grid2D.update(grid_acc, flash_pos, fn %{energy: energy} = cell_state -> %{cell_state | energy: energy + flash_count} end)
          end)
        # mark the octopi who have flashed once this turn
        grid_for_next_step =
          Enum.reduce(flashers, grid_after_flashes, fn {flasher_pos, cell_state}, grid_acc ->
            Grid2D.update(grid_acc, flasher_pos, %{cell_state | flashed?: true})
          end)


        # do it all again, letting the base case handle it if we're done.
        simulate_flashes(grid_for_next_step)
      end
    end

    @doc """
    Increases the energy of each octopus by 1.
    """
    def increase_energy_levels(grid) do
      Grid2D.map(grid, fn {_pos, %{energy: energy} = cell_state} -> %{cell_state | energy: energy + 1} end)
    end

    @doc """
    Simulate the given number of steps on the grid.

    Returns a map containing the resulting grid and total number of flashes that occurred during the simulation.

    For each step of the simulation:
    * First, the energy level of each octopus increases by 1.
    * Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1,
      including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than 9,
      it also flashes. This process continues as long as new octopuses keep having their energy level increased beyond 9.
      (An octopus can only flash at most once per step.)
    * Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
    """
    def do_steps(grid, step_count) do
      Enum.reduce(
        1..step_count, # we run this function on the state step_count times
        %{grid: grid, total_flashes: 0}, # we need to track the flash count, and also pass the grid to each iteration
        fn _step_number, %{grid: current_grid, total_flashes: current_flashes} ->

        after_flashes =
          current_grid
          |> increase_energy_levels()
          |> simulate_flashes()

        flashes_this_turn = Enum.count(after_flashes, fn {_pos, %{flashed?: flashed?}} -> flashed? end)

        grid_for_next_step =
          after_flashes
          |> Grid2D.map(fn {_pos, cell_state} -> %{cell_state | flashed?: false} end)
          |> Grid2D.map(fn {_pos, %{energy: energy} = cell_state} ->
            if energy > 9 do
              %{cell_state | energy: 0}
            else
              cell_state
            end
          end)

        new_flash_count = flashes_this_turn + current_flashes

        %{ grid: grid_for_next_step,
           total_flashes: new_flash_count }
      end)
    end

    @doc """
    Simulate until we find a step on which all the octopi flash simultaneously.
    """
    def find_first_megaflash(grid) do
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(grid, fn iteration, grid_acc ->
        %{ grid: grid_after_this_iteration } = do_steps(grid_acc, 1)

        if Grid2D.all?(grid_after_this_iteration, fn {_pos, %{energy: energy}} -> energy == 0 end) do
          {:halt, iteration}
        else
          {:cont, grid_after_this_iteration}
        end
      end)
    end

    def part_1(input) do
      %{total_flashes: total_flashes} =
        input
        |> input_to_grid()
        |> do_steps(100)
      total_flashes
    end

    def part_2(input) do
      input
      |> input_to_grid()
      |> find_first_megaflash()
    end
  end
