defmodule Aoc2021.Day08 do
  @moduledoc """
  --- Day 8: Seven Segment Search ---

  You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

  As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

  Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

    0:      1:      2:      3:      4:
  aaaa    ....    aaaa    aaaa    ....
  b    c  .    c  .    c  .    c  b    c
  b    c  .    c  .    c  .    c  b    c
  ....    ....    dddd    dddd    dddd
  e    f  .    f  e    .  .    f  .    f
  e    f  .    f  e    .  .    f  .    f
  gggg    ....    gggg    gggg    ....

    5:      6:      7:     8:      9:
  aaaa    aaaa    aaaa    aaaa    aaaa
  b    .  b    .  .    c  b    c  b    c
  b    .  b    .  .    c  b    c  b    c
  dddd    dddd    ....    dddd    dddd
  .    f  e    f  .    f  e    f  .    f
  .    f  e    f  .    f  e    f  .    f
  gggg    gggg    ....    gggg    gggg

  So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

  The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)

  So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). For that, you'll need to collect more information.

  For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

  For example, here is what you might see in a single entry in your notes:

  acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
  cdfeb fcadb cdfeb cdbaf

  (The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)

  Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.

  Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.

  For now, focus on the easy digits. Consider this larger example:

  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
  fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
  fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
  cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
  efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
  gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
  gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
  cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
  ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
  gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
  fgae cfgab fg bagce

  Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

  In the output values, how many times do digits 1, 4, 7, or 8 appear?

  --- Part Two ---

  Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

  acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
  cdfeb fcadb cdfeb cdbaf

  After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

  dddd
  e    a
  e    a
  ffff
  g    b
  g    b
  cccc

  So, the unique signal patterns would correspond to the following digits:

    acedgfb: 8
    cdfbe: 5
    gcdfa: 2
    fbcad: 3
    dab: 7
    cefabd: 9
    cdfgeb: 6
    eafb: 4
    cagedb: 0
    ab: 1

  Then, the four digits of the output value can be decoded:

    cdfeb: 5
    fcadb: 3
    cdfeb: 5
    cdbaf: 3

  Therefore, the output value for this entry is 5353.

  Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

    fdgacbe cefdb cefbgd gcbe: 8394
    fcgedb cgb dgebacf gc: 9781
    cg cg fdcagb cbg: 1197
    efabcd cedba gadfec cb: 9361
    gecf egdcabf bgf bfgea: 4873
    gebdcfa ecba ca fadegcb: 8418
    cefg dcbef fcge gbcadfe: 4548
    ed bcgafe cdgba cbgef: 1625
    gbdfcae bgc cg cgb: 8717
    fgae cfgab fg bagce: 4315

  Adding all of the output values in this larger example produces 61229.

  For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?


  ====

  My notes:

  OK so - part one should be quite easy, basically just count the n-length segments in the outputs, where n is the number of
  segments for the numbers 1, 4, 7, and 8.

  I don't yet know what Part 2 will entail, but it almost _has_ to be actually figuring out the value of each output (and then
  summing them or something). We can always figure out 1, 4, 7, and 8, since they are unique, and we should be able to go down
  a chain of deductions from the information we gain from that exercise to figure out the other digits.

  So real quick, here is a table of the number of segments that each possible digit uses:
  0 | 6
  1 | 2
  2 | 5
  3 | 5
  4 | 4
  5 | 5
  6 | 6
  7 | 3
  8 | 7
  9 | 6

  So 4 of the numbers you get for free just based on the length of the segment string.
  For the other 6 numbers, you have to distinguish them from each other based on information you already have.

  For the purposes of this next bit, we'll use the segment labels from the puzzle input:

     AAAA
    B    C
    B    C
     DDDD
    E    F
    E    F
     GGGG

  This table shows you the sections you can learn the mapping for from the digits that are trivial. 8, however, is kind of
  a special case because it doesn't really tell you much, since it covers all the segments.

  1 covers segments C and F
  4 covers segments C, F, D, and B
  7 covers segments C, F, and A

  So that gives you 5 "freebie" segments (c,f,d,b,a), leaving only E and G undetermined.

  There are 3 digits that use 6 segments (0, 6, 9) and 3 that use 5 (2, 3, and 5)
  2 covers A, C, D, E, G
  3 covers A, C, D, F, G
  5 covers A, B, D, F, G
  0 covers A, B, C, E, F, G
  6 covers A, B, D, E, F, G
  9 covers A, B, C, D, F, G

  Ah, so I just thought of something. While you can determine the _values_ for representations of 0,4,7, and 8 for free, you
  don't know which _segments_ are which for free - for example, if you have "fc" for number one, you can't be sure whether
  the segment mapping is %{ f => F, c => C} or %{ f => C, c => F}.

  Hmmmm.

  You can determine the mapping for segment A via the difference between 1 and 7

  Once you know segment A, you can get G by finding the signal which has segment A and all components of 4 and 1 unknown
  (this signal is number 9)


  From the difference between 1 and 7 you know two segments are definitely on the right side. of the five segment numbers,
  only 3 contains both of these segments. This lets you learn the three middle segments
  (and since you know a, you know the other two are either D or G)

  9 will contain two of the right side segments, but 6 will only contain 1. Eight will contain both. That allows you to map F

  2 will contain segment F but 5 will not so now we can map everything but 9 and 0

  Since we know the two lower middle segments from the information from 3, 7, and 1, we can determine 9 (it will contain
  both of those segments, whereas 0 will only contain one)

  So I think from all that we can map every number.

  I don't think it's technically necessary to map every segment but maybe we'll try to produce that as well for fun

  We will store the signals as map sets and then map those to digits?
  """

  @doc """
  From a single puzzle input string, deduce the mapping of signals to digits, and also the mapping of
  characters to segments.

  For naming purposes in the code below, I'm using capital letters to refer to each segment, with
  the following map of the segments:

  Notes on the process of deduction exist both in the moduledoc and code comments in this function.

  Segment map:

   AAAA
  B    C
  B    C
   DDDD
  E    F
  E    F
   GGGG

  ## Examples
  iex> line_str = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
  ...> map_signals_and_segments(line_str)
  %{
    segment_map: %{
      "a" => "C",
      "b" => "F",
      "c" => "G",
      "d" => "A",
      "e" => "B",
      "f" => "D",
      "g" => "E"
    },
    signal_map: %{
      MapSet.new(["a", "b"]) => 1,
      MapSet.new(["a", "b", "d"]) => 7,
      MapSet.new(["a", "b", "e", "f"]) => 4,
      MapSet.new(["a", "b", "c", "d", "f"]) => 3,
      MapSet.new(["a", "c", "d", "f", "g"]) => 2,
      MapSet.new(["b", "c", "d", "e", "f"]) => 5,
      MapSet.new(["a", "b", "c", "d", "e", "f"]) => 9,
      MapSet.new(["a", "b", "c", "d", "e", "g"]) => 0,
      MapSet.new(["b", "c", "d", "e", "f", "g"]) => 6,
      MapSet.new(["a", "b", "c", "d", "e", "f", "g"]) => 8
    }
  }

  """
  def map_signals_and_segments(line_str) do
    [ signal_str, _display_str ] = String.split(line_str, " | ")

    signals =
      String.split(signal_str, " ")
      |> Enum.map(&(String.split(&1, "", trim: true)))
      |> Enum.map(&MapSet.new/1)

    # map the easy ones first. these have unique numbers of segments, and establish a basis for
    # making deductions about the other digits.
    signal_1 = Enum.find(signals, &(Enum.count(&1) == 2))
    signal_4 = Enum.find(signals, &(Enum.count(&1) == 4))
    signal_7 = Enum.find(signals, &(Enum.count(&1) == 3))
    signal_8 = Enum.find(signals, &(Enum.count(&1) == 7))

    # next we figure out the signal for 3.
    # 3 is the only 5-segment digit which uses both of the right side segments (segments C and F)
    # this means that, of the 5 segment digits, only 3 will have two values in its intersection with 1

    signal_3 = Enum.find(signals, fn signal ->
      segment_count = Enum.count(signal)
      right_side_segments_in_signal = Enum.count(MapSet.intersection(signal, signal_1))

      segment_count == 5 and right_side_segments_in_signal == 2
    end)

    # we can deduce the signal for 6 in a similar manner. it is the only 6-segment digit which does _not_
    # contain both of the right side digits
    signal_6 = Enum.find(signals, fn signal ->
      segment_count = Enum.count(signal)
      right_side_segments_in_signal = Enum.count(MapSet.intersection(signal, signal_1))

      segment_count == 6 and right_side_segments_in_signal == 1
    end)

    # from here on, we need to start mapping some of the individual segments to be able to distinguish
    # other signals. at this point, we have determined 6 of 10 digits (1,3,4,6,7, and 8), leaving 4 digits
    # to map - 0, 2, 5, and 9. 0 and 9 each use six segments, and 2 and 5 each use five segments, which
    # means we need to find methods to distinguish 2 and 5 from each other, and also to distingusish 9 from 0.

    # we'll start by mapping any segments we already know about. it is not technically necessary to produce
    # a complete map of the segments, but we're going to try for extra credit.

    # segment A is the difference between the segments in 1 and 7.
    # also, order matters in the difference call. all members of set_2 are removed from set_1
    segment_A_char = MapSet.difference(signal_7, signal_1) |> Enum.into("")

    # we can map segments C and F with the information from signal_1 and signal_6.
    # since we know that the segments in 1 are both on the right side of the display, the one that is
    # _not_ in 6 is segment C, and the one that is shared between 6 and 1 is segment F
    segment_C_char = MapSet.difference(signal_1, signal_6) |> Enum.into("")
    segment_F_char = MapSet.intersection(signal_6, signal_1) |> Enum.into("")

    # now that we've determined which segment is which on the right side, we can use that information
    # to differentiate between the signals for 5 and 2. There's a couple different way you could go about it,
    # this is just one.
    signal_2 = Enum.find(signals, fn signal ->
      segment_count = Enum.count(signal)

      segment_count == 5
      and signal != signal_3
      and MapSet.member?(signal, segment_C_char)
    end)

    signal_5 = Enum.find(signals, fn signal ->
      segment_count = Enum.count(signal)

      segment_count == 5
      and signal != signal_3
      and MapSet.member?(signal, segment_F_char)
    end)

    # at this point, we know the signals for all the numbers but 9 and 0. We know the mappings for segments
    # A, C, and F. Since all those segments shared by 9 and 0, we'll need to determine a few more.
    # just like with 5 and 2, we have a lot of paths we could take to deduce these at this point.

    # we can play this "repeated set difference" game to narrow down segments
    segment_E_char =
      signal_8
      |> MapSet.difference(signal_3)
      |> MapSet.difference(signal_4)
      |> Enum.into("")

    # the signal for 9 will not contain segment E. we can use that to determine 9.
    signal_9 = Enum.find(signals, fn signal ->
      segment_count = Enum.count(signal)

      segment_count == 6
      and signal != signal_6
      and not MapSet.member?(signal, segment_E_char)
    end)

    # the signal for 0 now follows by process of elimination
    signal_0 = Enum.find(signals, fn signal ->
      segment_count = Enum.count(signal)

      segment_count == 6
      and signal != signal_6
      and signal != signal_9
    end)

    # at this point we know all the digits, so we can solve the puzzle. but we're only three
    # signals from a complete mapping, so we might as well figure 'em out. segments B, D, and G
    # remain to be determined

    # this returns the signals for two bottom middle segments (D and G).
    signals_for_D_and_G = MapSet.difference(signal_3, signal_7)

    # only one of these two segments appears in digit 0, so we can use that to determine G.
    # once we determine G we get D as a 'freebie'
    segment_G_set = MapSet.intersection(signal_0, signals_for_D_and_G)

    segment_D_char = MapSet.difference(signals_for_D_and_G, segment_G_set) |> Enum.into("")
    segment_G_char = Enum.into(segment_G_set, "")

    # last segment to map is B
    segment_B_char =
      MapSet.difference(signal_4, MapSet.new([segment_C_char, segment_F_char, segment_D_char]))
      |> Enum.into("")

    signal_map = %{
      signal_1 => 1,
      signal_2 => 2,
      signal_3 => 3,
      signal_4 => 4,
      signal_5 => 5,
      signal_6 => 6,
      signal_7 => 7,
      signal_8 => 8,
      signal_9 => 9,
      signal_0 => 0,
    }

    segment_map = %{
      segment_A_char => "A",
      segment_B_char => "B",
      segment_C_char => "C",
      segment_D_char => "D",
      segment_E_char => "E",
      segment_F_char => "F",
      segment_G_char => "G",
    }

    %{
      signal_map: signal_map,
      segment_map: segment_map
    }
  end

  @doc """
  Given a string formatted like the puzzle input, returns the number on the display.
  """
  def deduce_disp_string_value(line_str) do
    %{
      signal_map: signal_map,
      segment_map: _segment_map,
    } = map_signals_and_segments(line_str)

    [ _signal_str, display_str ] = String.split(line_str, " | ")

    display_str
    |> String.split(" ")
    |> Enum.map(fn digit_signal_str ->
      String.split(digit_signal_str, "", trim: true)
      |> MapSet.new()
      |> (&(Map.get(signal_map, &1))).()
    end)
    |> Integer.undigits()
  end


  def part_1(input) do
    input
    |> Enum.map(fn line ->
      [ _ , display_str ] = String.split(line, " | ")
      display_str
    end)
    |> Enum.map(&(String.split(&1, " ")))
    |> List.flatten()
    |> Enum.count(fn display_digit ->
      segment_count = String.length(display_digit)

      (segment_count == 2
        or segment_count == 3
        or segment_count == 4
        or segment_count == 7)
    end)
  end

  def part_2(input) do
    input
    |> Enum.map(&deduce_disp_string_value/1)
    |> Enum.sum()
  end
end
