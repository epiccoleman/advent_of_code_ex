defmodule Day18 do

  def evaluate_tree({operation, a, b}) do
    a_eval = case a do
      {:number, n} -> n
      expr when is_tuple(expr) -> evaluate_tree(expr)
    end
    b_eval = case b do
      {:number, n} -> n
      expr when is_tuple(expr) -> evaluate_tree(expr)
    end

    case operation do
      :mult -> a_eval * b_eval
      :plus -> a_eval + b_eval
    end
  end

  def eval_part_2(input_str) do
    Day18.Parser.parse_weird_order(input_str)
    |> evaluate_tree()
  end

  def part_1(input) do
    input
    |> Enum.map(&Day18.Parser.parse_left_right/1)
    |> Enum.map(&evaluate_tree/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Enum.map(&Day18.Parser.parse_weird_order/1)
    |> Enum.map(&evaluate_tree/1)
    |> Enum.sum()
  end



  #### Historical, for funsies:



  # deprecated this version in favor of the tree one, which is probably a better implementation
  # and which should be compatible with the next parser???

  # def part_1(input) do
  #   input
  #   |> Enum.map(&evaluate/1)
  #   |> Enum.sum()
  # end


  def evaluate([a, op, b | rest]) do
    a_eval = if is_list(a) do evaluate(a) else a end
    b_eval = if is_list(b) do evaluate(b) else b end

    operation = case op do
      ~c"+" -> &+/2
      ~c"-" -> &-/2
      ~c"*" -> &*/2
      ~c"/" -> &//2
    end

    evaluate([operation.(a_eval, b_eval)] ++ rest)
  end

  def evaluate([value]) do
    value
  end
  def evaluate(input_line) when is_binary(input_line) do
    Day18.Parser.parse_to_list(input_line)
    |> evaluate()
  end

end
