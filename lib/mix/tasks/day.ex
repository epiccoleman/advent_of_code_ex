defmodule Mix.Tasks.Day do

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    day_number = args |> hd

    response = IO.gets "Create files for Day #{day_number}? [Y/n]"

    if response =~ ~r{[yY]} or response =~ ~r[^\n$] do
      write_day_module("01")
    else
      IO.puts "Not creating files..."
    end
  end

  def write_day_module(day_number) do

    day_name = "day#{day_number}"
    day_module_name = "Day#{day_number}"
    day_lib_dir = "#{File.cwd!}/lib/#{day_name}"
    day_module_path = "#{day_lib_dir}/#{day_name}.ex"

    day_test_dir = "#{File.cwd!}/test/#{day_name}"
    day_test_module_path = "#{day_test_dir}/#{day_name}_test.exs"

    # create module dir
    File.mkdir!(day_lib_dir)
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
    File.mkdir!(day_test_dir)
    #day_test_module_path = "#{day_test_dir}/#{day_name}.ex"
    File.write!(
      day_test_module_path,
      """
      defmodule #{day_module_name}Test do
        use ExUnit.Case

        test "Part 1" do
          input = FileUtils.get_file_as_integers("#{day_test_dir}/input.txt")
          assert #{day_module_name}.part_1(input) == 0
        end

        test "Part 2" do
          input = FileUtils.get_file_as_integers("#{day_test_dir}/input.txt")
          assert #{day_module_name}.part_2(input) == 0
        end
      end
      """
    )

    File.write!("#{day_test_dir}/input.txt", "0")
  end
end
