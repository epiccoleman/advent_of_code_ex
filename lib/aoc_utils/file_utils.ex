defmodule AocUtils.FileUtils do
  @moduledoc """
  Defines some utility functions for processing puzzle input files.
  """

  @doc """
  Reads an input file and returns its lines as a list of strings.
  """
  def get_file_as_strings(file_path) do
    File.read!(file_path)
    |> String.split("\n")
  end

  @doc """
  Reads an input file and returns its contents as a list of integers.
  """
  def get_file_as_integers(file_path) do
    get_file_as_strings(file_path)
    |> Enum.map(&String.to_integer/1)
  end
end
