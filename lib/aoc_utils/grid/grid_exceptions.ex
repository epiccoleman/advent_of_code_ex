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
