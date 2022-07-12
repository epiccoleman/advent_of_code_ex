defmodule Mix.Tasks.Day do

  use Mix.Task

  @impl Mix.Task
  def run([number, year | args ]) do

    day_number = String.pad_leading(number, 2, "0")

    IO.puts "You didn't code any protection from deleting untracked code with this..."
    response = IO.gets "Create files for AOC #{year} Day #{day_number}? [Y/n]"

    if response =~ ~r{[yY]} or response =~ ~r[^\n$] do
      write_day_module(day_number, year)
    else
      IO.puts "Not creating files..."
    end
  end

  def write_day_module(day_number, year) do
    aoc_year = "aoc_#{year}"
    day_name = "day#{day_number}"
    day_module_name = "Aoc#{year}.Day#{day_number}"
    day_lib_dir = "#{File.cwd!}/lib/#{aoc_year}/#{day_name}"
    day_module_path = "#{day_lib_dir}/#{day_name}.ex"

    day_test_dir = "#{File.cwd!}/test/#{aoc_year}/#{day_name}"
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

    #create test dir
    File.mkdir_p!(day_test_dir)
    File.write!(
      day_test_module_path,
      """
      defmodule #{day_module_name}Test do
        use ExUnit.Case
        import AOCUtils.FileUtils
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

    File.write!("#{day_test_dir}/input.txt", "0")
  end
end
