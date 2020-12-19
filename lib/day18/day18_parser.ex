defmodule Day18.Parser do
  def parse_to_list(str) do
    parened_str = "(" <> str <> ")"
    {:ok, tokens, _} = parened_str |> to_charlist() |> :day18_lexer_list.string()
    {:ok, list} = :day18_parser_list.parse(tokens)
    list
  end

  def parse_left_right(str) do
    {:ok, tokens, _} = str |> to_charlist() |> :day18_lexer_tree.string()
    {:ok, list} = :day18_parser_left_right.parse(tokens)
    list
  end

  def parse_weird_order(str) do
    {:ok, tokens, _} = str |> to_charlist() |> :day18_lexer_tree.string()
    {:ok, list} = :day18_parser_weird_order.parse(tokens)
    list
  end

end
