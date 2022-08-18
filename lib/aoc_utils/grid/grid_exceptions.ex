defmodule AocUtils.Grid2D.InvalidGridDimensionsError do
  @moduledoc """
  Indicates an error when the user tries to create a Grid2D with invalid dimensions.
  """

  alias AocUtils.Grid2D.InvalidGridDimensionsError
  defexception [:message]

  @impl true
  def exception(message) when is_binary(message) do
    %InvalidGridDimensionsError{message: message}
  end
end

defmodule AocUtils.Grid2D.GridAccessError do
  @moduledoc """
  Indicates an error state when the user tries to access a non-existent cell in the Grid2D.

  Includes the index in the error message.
  """
  alias AocUtils.Grid2D.GridAccessError
  defexception [:message]

  # @impl true
  # def exception(key) do
  #   msg = "Attempted to access non-existent Grid cell at position: #{inspect(key)}"
  #   %GridAccessError{message: msg}
  # end

  @impl true
  def exception(message) when is_binary(message) do
    %GridAccessError{message: message}
  end
end
