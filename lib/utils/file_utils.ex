defmodule FileUtils do
  def get_file_as_strings(file_path) do
    File.read!(file_path)
    |> String.split("\n")
  end
  def get_file_as_integers(file_path) do
    get_file_as_strings(file_path)
    |> Enum.map(&String.to_integer/1)
  end
end
