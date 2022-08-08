defmodule AocUtils.Grid2D.GridAccessError do
  @doc """
  Indicates an error state when the user tries to access a non-existent cell in the Grid2D.

  Includes the index in the error message.
  """
  alias AocUtils.Grid2D.GridAccessError
  defexception [:message]

  @impl true
  def exception(key) do
    msg = "Attempted to access non-existent Grid cell at position: #{inspect(key)}"
    %GridAccessError{message: msg}
  end
end

defmodule AocUtils.Grid2D.InvalidMergeError do
  @doc """
  Indicates an error when the user attempts to merge two Grids in a manner that would result in a non-rectangular grid.

  Includes the index in the error message.
  """
  alias AocUtils.Grid2D.GridAccessError
  defexception [:message]

  @impl true
  def exception(offset) do
    msg = "The proposed merge of the given grids at #{inspect(offset)} would result in a non-rectangular grid."
    %GridAccessError{message: msg}
  end
end
