defmodule Mix.Tasks.Day do
  use Mix.Task

  @impl Mix.Task
  def run([number, year | _args]) do
    IO.puts("You didn't code any protection from deleting untracked code with this...")
    response = IO.gets("Create files for AOC #{year} Day #{number}? [Y/n]")

    if response =~ ~r{[yY]} or response =~ ~r[^\n$] do
      write_day_module(number, year)
    else
      IO.puts("Not creating files...")
    end
  end

  def write_day_module(day, year) do
    day_number = String.pad_leading(day, 2, "0")

    aoc_year = "aoc_#{year}"
    day_name = "day#{day_number}"
    day_module_name = "Aoc#{year}.Day#{day_number}"
    day_lib_dir = "#{File.cwd!()}/lib/#{aoc_year}/#{day_name}"
    day_module_path = "#{day_lib_dir}/#{day_name}.ex"

    day_test_dir = "#{File.cwd!()}/test/#{aoc_year}/#{day_name}"
    day_test_module_path = "#{day_test_dir}/#{day_name}_test.exs"

    # create module dir
    File.mkdir_p!(day_lib_dir)
    # create module
    File.write!(
      day_module_path,
      """
      defmodule #{day_module_name} do
        def part_1(input) do
          input
        end

        def part_2(input) do
          input
        end
      end
      """
    )

    # create test dir
    File.mkdir_p!(day_test_dir)

    File.write!(
      day_test_module_path,
      """
      defmodule #{day_module_name}Test do
        use ExUnit.Case
        import AocUtils.FileUtils
        import #{day_module_name}

        #test "Part 1" do
        #  input = get_file_as_strings("./test/#{aoc_year}/#{day_name}/input.txt")
        #  assert part_1(input) == 0
        #end

        #test "Part 2" do
        #  input = get_file_as_strings("./test/#{aoc_year}/#{day_name}/input.txt")
        #  assert part_2(input) == 0
        #end
      end
      """
    )

    puzzle_input = AocUtils.SiteUtils.get_puzzle_input(day, year)
    File.write!("#{day_test_dir}/input.txt", puzzle_input)

    # Removing this in favor of not fetching the description by default,
    # since Eric Wastl has asked that puzzle repos don't reproduce the puzzle text.
    # At some point I should go clean up the existing puzzle texts in this repo but ...

    # puzzle_desc = AocUtils.SiteUtils.get_puzzle_description_pt_1(day, year)
    # File.write!("#{day_lib_dir}/part1.md", puzzle_desc)
  end
end

defmodule Mix.Tasks.Day.Desc do
  use Mix.Task

  @impl Mix.Task
  def run([number, year, part | _args]) do
    response = IO.gets("Fetch description for AOC #{year} Day #{number} Part #{part}? [Y/n]")

    if response =~ ~r{[yY]} or response =~ ~r[^\n$] do
      cond do
        part == "1" ->
          write_description_pt_1(number, year)

        part == "2" ->
          write_description_pt_2(number, year)
      end
    else
      IO.puts("Not creating files...")
    end
  end

  def write_description_pt_1(day, year) do
    day_number = String.pad_leading(day, 2, "0")

    aoc_year = "aoc_#{year}"
    day_name = "day#{day_number}"
    day_lib_dir = "#{File.cwd!()}/lib/#{aoc_year}/#{day_name}"

    puzzle_desc = AocUtils.SiteUtils.get_puzzle_description_pt_1(day, year)
    File.write!("#{day_lib_dir}/puzzle_description.md", puzzle_desc)
  end

  def write_description_pt_2(day, year) do
    day_number = String.pad_leading(day, 2, "0")

    aoc_year = "aoc_#{year}"
    day_name = "day#{day_number}"
    day_lib_dir = "#{File.cwd!()}/lib/#{aoc_year}/#{day_name}"

    puzzle_desc = AocUtils.SiteUtils.get_puzzle_description_pt_2(day, year)
    File.write!("#{day_lib_dir}/puzzle_description.md", "\n", [:append])
    File.write!("#{day_lib_dir}/puzzle_description.md", puzzle_desc, [:append])
  end
end
