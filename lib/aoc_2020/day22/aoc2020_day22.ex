  defmodule Day22 do

    def process_input(input) do
      [p1, p2] =
        String.split(input,"\n\n")
        |> Enum.map(&(String.split(&1, "\n")))
        |> Enum.map(fn deck ->
          [_ | deck ] = deck

          deck
          |> Enum.map(&String.to_integer/1)
        end)

      %{p1: p1, p2: p2}
    end

    def play_game(%{p1: p1_deck, p2: p2_deck}) do
      if Enum.empty?(p1_deck) or Enum.empty?(p2_deck) do
        %{p1: p1_deck, p2: p2_deck}
      else
        [ p1_card | p1_rest_deck ] = p1_deck
        [ p2_card | p2_rest_deck ] = p2_deck

        next = if p1_card > p2_card do
          %{
            p1: p1_rest_deck ++ [ p1_card, p2_card],
            p2: p2_rest_deck
          }
        else
          %{
            p2: p2_rest_deck ++ [ p2_card, p1_card],
            p1: p1_rest_deck
          }
        end
        play_game(next)
      end
    end

    def score_deck(deck) do
      deck
      |> Enum.reverse
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {a, b}, acc -> acc + a*b end)
    end

    #
    # Before either player deals a card, if there was a previous round in this game that had exactly the same cards in the same order in the same players' decks, the game instantly ends in a win for player 1. Previous rounds from other games are not considered. (This prevents infinite games of Recursive Combat, which everyone agrees is a bad idea.)
    # Otherwise, this round's cards must be in a new configuration; the players begin the round by each drawing the top card of their deck as normal.
    # If both players have at least as many cards remaining in their deck as the value of the card they just drew, the winner of the round is determined by playing a new game of Recursive Combat (see below).
    # Otherwise, at least one player must not have enough cards left in their deck to recurse; the winner of the round is the player with the higher-value card.

    def recursive_combat(%{p1: p1, p2: p2, seen: seen, winner: _winner} = state) do
      cond do
        # winner -> state # game is over, don't think should ever happen?
        Enum.member?(seen, {p1, p2}) -> Map.put(state, :winner, :p1)
        Enum.empty?(p1) -> Map.put(state, :winner, :p2)
        Enum.empty?(p2) -> Map.put(state, :winner, :p1)



        true -> # play a round, all of these trigger some variety of recursive call
          # draw the top cards
          [ p1_card | p1_rest ] = p1
          [ p2_card | p2_rest ] = p2

          play_subgame? = (p1_card <= length(p1_rest) and p2_card <= length(p2_rest))

          if play_subgame? do
            p1_subdeck = Enum.slice(p1_rest, 0..p1_card-1)
            p2_subdeck = Enum.slice(p2_rest, 0..p2_card-1)

            winner = recursive_combat(%{p1: p1_subdeck, p2: p2_subdeck, seen: [], winner: nil}).winner

            next = if winner == :p1 do
              %{
                p1: p1_rest ++ [ p1_card, p2_card],
                p2: p2_rest,
                seen: seen ++ [{p1, p2}],
                winner: nil
              }
            else
              %{
                p2: p2_rest ++ [ p2_card, p1_card],
                p1: p1_rest,
                seen: seen ++ [{p1, p2}],
                winner: nil
              }
            end
            recursive_combat(next)

          else
            next = if p1_card > p2_card do
              %{
                p1: p1_rest ++ [ p1_card, p2_card],
                p2: p2_rest,
                seen: seen ++ [{p1, p2}],
                winner: nil
              }
            else
              %{
                p2: p2_rest ++ [ p2_card, p1_card],
                p1: p1_rest,
                seen: seen ++ [{p2, p1}],
                winner: nil
              }
            end

            recursive_combat(next)
          end
      end
    end



    def part_1(input) do
      end_state = input
      |> process_input()
      |> play_game()

      {_, winner_deck} = Enum.filter(end_state, fn {_, deck} -> not Enum.empty?(deck) end) |> hd

      score_deck(winner_deck)
    end

    def part_2(input) do
      %{p1: p1, p2: p2} = input
      |> process_input()

      initial = %{p1: p1, p2: p2, seen: [], winner: nil}

      end_state = recursive_combat(initial)

      winner = end_state.winner
      winner_deck = end_state[winner]

      score_deck(winner_deck)
    end
  end
