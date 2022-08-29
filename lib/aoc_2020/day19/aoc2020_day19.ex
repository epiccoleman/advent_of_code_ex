defmodule Day19 do

  def expand_rule(rule, rules) do
    case rule do
      "a" -> "a"
      "b" -> "b"
      n when is_integer(n) -> expand_rule(Map.get(rules, n), rules)
      l when is_list(l) -> Enum.map(l, &(expand_rule(&1, rules)))
    end
  end

  def list_to_regex(list) do
    Enum.map(list, fn item ->
      case item do
        "a" -> "a"
        "b" -> "b"
        [[_c1, _c2] = c, [_d1, _d2] = d] -> "(#{list_to_regex(c)}|#{list_to_regex(d)})"
        [ c1, c2 ] -> "#{c1}#{c2}"
        other -> list_to_regex(other)
      end
    end)
  end

  def expand_rule_str(rule_str, rule_strs) do
    hmm = rule_str |> String.split(" ")

    Enum.map(hmm, fn token ->
      case token do
        "a" -> "a"
        "b" -> "b"
        "|" -> "|"
        "+" -> "+"
        token -> expand_rule_str(Map.get(rule_strs, String.to_integer(token)), rule_strs)
      end
    end)
    |> Enum.join
    |> (&("(#{&1})")).()
  end

  def part_1(input) do
    rule_strs = Day19.Rules.rule_strs()
    rule_0 = Map.get(rule_strs, 0)
    bigass_regex = Regex.compile!("^" <> expand_rule_str(rule_0, rule_strs) <> "$")

    input
    |> Enum.filter(&(&1 =~ bigass_regex))
    |> Enum.count()
  end

  def part_2(input) do
    rule_strs = Day19.Rules.rule_strs

    rule_42 = expand_rule_str(Map.get(rule_strs, 42), rule_strs)
    rule_31 = expand_rule_str(Map.get(rule_strs, 31), rule_strs)

    rule_8 = "(#{rule_42})+"
    # oh my god
    # you can't just use (?R) because that matches the whole regex
    # you can get around this with a named capture
    rule_11 = "(?<rule_11>#{rule_42}(?&rule_11)?#{rule_31})"

    big_regex_str = "^" <> rule_8 <> rule_11 <> "$"

    bigass_regex = Regex.compile!(big_regex_str)

    input
    |> Enum.filter(&(&1 =~ bigass_regex))
    |> Enum.count()
  end
end
