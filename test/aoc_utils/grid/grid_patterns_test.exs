defmodule GridPatternsTest do
  use ExUnit.Case
  doctest AocUtils.Grid2D.Patterns, import: true

  alias AocUtils.Grid2D
  alias AocUtils.Grid2D.Patterns.InvalidGridPatternMatchError

  import AocUtils.Grid2D.Patterns

  describe("pattern_match_at_location?") do
    test "raises GridPatternMatchError when pattern x_max is larger than source" do
      source_grid =
        [
          "...",
          "..."
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "....",
          "...."
        ]
        |> Grid2D.from_strs()

      assert_raise(InvalidGridPatternMatchError, fn ->
        pattern_match_at_location?(source_grid, pattern_grid, {0, 0})
      end)
    end

    test "raises GridPatternMatchError when pattern y_max is larger than source" do
      source_grid =
        [
          "...",
          "..."
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "..",
          "..",
          ".."
        ]
        |> Grid2D.from_strs()

      assert_raise(InvalidGridPatternMatchError, fn ->
        pattern_match_at_location?(source_grid, pattern_grid, {0, 0})
      end)
    end

    test "raises GridPatternMatchError when pattern x size is larger than source" do
      source_grid =
        [
          "...",
          "..."
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          {{-2, 0}, 1},
          {{-1, 0}, 1},
          {{0, 0}, 1},
          {{1, 0}, 1}
        ]
        |> Grid2D.from_list()

      assert_raise(InvalidGridPatternMatchError, fn ->
        pattern_match_at_location?(source_grid, pattern_grid, {0, 0})
      end)
    end

    test "raise GridPatternMatchError if the given origin would cause the pattern grid to exceed the source grid's boundaries" do
      source_grid =
        [
          "...",
          "...",
          "..."
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "..",
          ".."
        ]
        |> Grid2D.from_strs()

      assert_raise(InvalidGridPatternMatchError, fn ->
        pattern_match_at_location?(source_grid, pattern_grid, {2, 0})
      end)
    end

    test "pattern match with full grid" do
      source_grid =
        [
          "ABC",
          "DEF",
          "GHI"
        ]
        |> Grid2D.from_strs()

      assert pattern_match_at_location?(source_grid, source_grid, {0, 0})
    end

    test "pattern match with partial grid" do
      source_grid =
        [
          "ABC",
          "DEF",
          "GHI"
        ]
        |> Grid2D.from_strs()

      pattern1_grid =
        [
          "AB",
          "DE"
        ]
        |> Grid2D.from_strs()

      pattern2_grid =
        [
          "EF"
        ]
        |> Grid2D.from_strs()

      pattern3_grid =
        [
          "C",
          "F",
          "I"
        ]
        |> Grid2D.from_strs()

      pattern4_grid =
        [
          "A..",
          ".E.",
          "..I"
        ]
        |> Grid2D.from_strs(ignore: ".")

      assert pattern_match_at_location?(source_grid, pattern1_grid, {0, 0})
      assert pattern_match_at_location?(source_grid, pattern2_grid, {1, 1})
      assert pattern_match_at_location?(source_grid, pattern3_grid, {2, 0})
      assert pattern_match_at_location?(source_grid, pattern4_grid, {0, 0})
    end
  end

  describe("count_pattern_occurences") do
    test("counts the pattern occurences in a wee baby grid") do
      source_grid =
        [
          "AB.AB"
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "AB"
        ]
        |> Grid2D.from_strs()

      assert count_pattern_occurences(source_grid, pattern_grid) == 2
    end

    test("counts the pattern occurences") do
      source_grid =
        [
          "AB...AB",
          "...AB..",
          "ABABAB."
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "AB"
        ]
        |> Grid2D.from_strs()

      assert count_pattern_occurences(source_grid, pattern_grid) == 6
    end

    test("counts multi-line patterns") do
      source_grid =
        [
          "AB...AB",
          "...AB..",
          "ABABAAB"
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "AB",
          "..",
          "AB"
        ]
        |> Grid2D.from_strs(ignore: ".")

      assert count_pattern_occurences(source_grid, pattern_grid) == 2
    end

    test("counts diagonal pattern") do
      source_grid =
        [
          "A..A...",
          ".A..A..",
          "..A..A."
        ]
        |> Grid2D.from_strs()

      pattern_grid =
        [
          "A..",
          ".A.",
          "..A"
        ]
        |> Grid2D.from_strs(ignore: ".")

      assert count_pattern_occurences(source_grid, pattern_grid) == 2
    end
  end
end
