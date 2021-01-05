defmodule Day25Test do
  use ExUnit.Case
  import Checkov

  import Day25

  data_test "transform_subject" do
    assert transform_subject(subject, loop_size) == result
    where [
      [:subject, :loop_size, :result],
      [7, 8, 5764801], # result is the card's public key
      [7, 11, 17807724], # result is the door's public key
      [17807724, 8, 14897079], # transforming the DOORs pk by the CARDs loop size produces the encryption key
      [5764801, 11, 14897079] # similar for transform CARD pk by the DOOR's loop size
    ]
  end

  ##
  ## 1717001 Key A
  ## 523731 Key B

  # the thing i have is the two public keys. i need to produce the encryption key
  # i need to find the loop size that results in each public key.

  # find a, b st (transform_subject(7, a) == 1717001 and transform_subject(7, b) == 523731

  # encryption key == transform_subject(523731, a) == transform_subject(1717001, b)


  test "Part 1" do
    input = [1717001, 523731]
    assert Day25.part_1(input) == 2679568
  end

  test "Part 2" do
    input = FileUtils.get_file_as_integers("test/day25/input.txt")
    assert Day25.part_2(input)
  end
end
