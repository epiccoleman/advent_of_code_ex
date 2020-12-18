defmodule Day18.Parser do
  @spec parse(binary) :: list
  def parse(str) do
    parened_str = "(" <> str <> ")"
    {:ok, tokens, _} = parened_str |> to_charlist() |> :day18_lexer.string()
    {:ok, list} = :day18_parser.parse(tokens)
    list
  end
end
