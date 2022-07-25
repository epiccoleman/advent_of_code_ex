defmodule AocUtils.MiscUtils do
@moduledoc """
Dumping ground for random useful functions.
"""

  @doc """
  When given a list, returns a map whose keys correspond to elements in the list, with values indicating the
  counts of those elements in the list.
  """
  def count_list_elements(list) do
    Enum.reduce(list, %{}, fn item, counts ->
      Map.update(counts, item, 1, fn count -> count + 1 end)
    end)
  end
end
