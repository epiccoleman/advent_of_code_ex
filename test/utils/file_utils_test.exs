# 3390830


defmodule FileUtilsTest do
  use ExUnit.Case

  test "#get_file_as_strings" do
    assert FileUtils.get_file_as_strings("test/utils/test_input.txt") == ["123", "456", "789"]
  end

  test "#get_file_as_ints" do
    assert FileUtils.get_file_as_integers("test/utils/test_input.txt") == [123, 456, 789]
  end
end
