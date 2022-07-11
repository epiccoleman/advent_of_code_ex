defmodule FileUtilsTest do
  use ExUnit.Case
  import AOCUtils.FileUtils

  test "#get_file_as_strings" do
    assert get_file_as_strings("./test/aoc_utils/test_input.txt") == ["123", "456", "789"]
  end

  test "#get_file_as_ints" do
    assert get_file_as_integers("./test/aoc_utils/test_input.txt") == [123, 456, 789]
  end
end
