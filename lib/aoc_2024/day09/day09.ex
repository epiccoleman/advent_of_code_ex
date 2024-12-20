defmodule Aoc2024.Day09 do
  def parse_disk_map(disk_map_str) do
    String.split(disk_map_str, "", trim: true)
    |> AocUtils.MiscUtils.digitify()
    |> Enum.chunk_every(2)
    |> Enum.reduce(
      {[], [], 0, 0},
      # this is completely hideous, but i cbf to come up with a more elegant way of expressing it rn.
      fn
        chonk, {current_files, current_free_spaces, current_index, current_file_id} ->
          case chonk do
            [new_file_size, new_free_space_size] when new_free_space_size != 0 ->
              new_file_start = current_index
              new_file_end = current_index + new_file_size - 1
              new_free_space_start = new_file_end + 1
              new_free_space_end = new_free_space_start + new_free_space_size - 1
              next_file_id = current_file_id + 1
              next_index = new_free_space_end + 1

              new_files = [{new_file_start..new_file_end, current_file_id} | current_files]
              new_free_spaces = [new_free_space_start..new_free_space_end | current_free_spaces]
              {new_files, new_free_spaces, next_index, next_file_id}

            # it feels like there's probably a way to combine these two but whatever
            [new_file_size, _zero_free_space ] ->
              new_file_start = current_index
              new_file_end = current_index + new_file_size - 1
              next_file_id = current_file_id + 1
              next_index = new_file_end + 1

              new_files = [{new_file_start..new_file_end, current_file_id} | current_files]
              {new_files, current_free_spaces, next_index, next_file_id}

            [new_file_size] ->
              new_file_start = current_index
              new_file_end = current_index + new_file_size - 1
              next_file_id = current_file_id + 1
              next_index = new_file_end + 1

              new_files = [{new_file_start..new_file_end, current_file_id} | current_files]
              {new_files, current_free_spaces, next_index, next_file_id}
          end
      end
    )
    |> then(fn {files, free_spaces, _, _} ->
      {files, Enum.reverse(free_spaces)}
    end)
  end

  @doc """
  move file blocks one at a time from the end of the disk to the leftmost free space block
  (until there are no gaps remaining between file blocks).

  this assumes that the free space list is sorted in left-to-right order (i.e. ascending)
  And that the files list is sorted in reverse order (i.e. right to left, so that we see files towards the end of the map first)

  this also assumes that the free space left over at the end doesn't matter, which will probably bite us in part 2 somehow, but oh well
  """

  def refragment({files, []} = _disk_map, _) do
    # :timer.sleep(1000)
    # IO.write("\r                                                         \r#{print_disk_map(arg)}")
    # IO.puts(print_disk_map(arg))
    files
  end

  # so what we need to do is to take a range of free space and fill it with "file"
  # this feels a bit inelegant but that seems to be the pattern today
  def refragment({[file_to_use | files], [free_space_range | rest]} = _disk_map, max_index) do
    # IO.puts("args: #{inspect(arg)}")

    # :timer.sleep(1000)
    # IO.puts(print_disk_map(arg))
    # IO.write("\r                                                         \r#{print_disk_map(arg)}")
    # IO.puts("entering refragment to process #{inspect(file_to_use)}")
    # IO.puts("with free_space_range: #{inspect(free_space_range)}")
    # IO.puts("files: #{inspect(files)}")
    # IO.puts("remaining free space: #{inspect(rest)}")
    free_space_size = Range.size(free_space_range)
    {file_range, file_id} = file_to_use
    file_size = Range.size(file_range)
    free_space_start..free_space_end = free_space_range
    file_range_start..file_range_end = file_range

    # always put "done" files on the back of the list - because we need to not reprocess them.
    # if this turns out to be a performance hit, we could keep processed files in a separate list and recombine
    # at the end, or we could check if the range we're working has already been filled. but let's try it this way to start.
    cond do
      free_space_start > max_index ->
        refragment({[file_to_use | files], rest}, max_index)
      free_space_end > max_index ->
        new_free_space_range = free_space_start..max_index
        refragment({[file_to_use | files], [new_free_space_range | rest]}, max_index)

      free_space_size == file_size ->
        # IO.puts("got equally sized file and range")
        new_file = {free_space_range, file_id}
        # IO.puts("calling with files: #{inspect(files ++ [new_file])}")
        # IO.puts("rest was: #{inspect(rest)}")
        refragment({files ++ [new_file], rest}, max_index)

      free_space_size > file_size ->
        # IO.puts("more free than file")
        file_end = free_space_start + file_size - 1
        file_range = free_space_start..file_end
        remaining_free_space_range = file_end+1..free_space_end
        new_file = {file_range, file_id}
        # IO.puts("calling refrag with files: #{inspect(files ++ [new_file])}")
        # IO.puts("free space: #{inspect([free_space_range | rest])}")
        refragment({files ++ [new_file], [remaining_free_space_range | rest]}, max_index)

      free_space_size < file_size ->
        # pull off end of file to fill free_space
        remaining_file_range = file_range_start..(file_range_end - free_space_size)
        remaining_file = {remaining_file_range, file_id}
        new_file = {free_space_range, file_id}

        # IO.puts("calling refragment with files: #{inspect([remaining_file | files] ++ [new_file])}")
        # IO.puts("and free space: #{inspect(rest)}")
        refragment({[remaining_file | files] ++ [new_file], rest}, max_index)
    end
  end

  def refragment(disk_map) do
    max_index = get_max_index(disk_map)
    refragment(disk_map, max_index)
  end

  def print_disk_map({files, free_space}) do
    files ++ free_space
    |> Enum.sort_by(
      fn {a.._, _} -> a
      a.._ -> a
    end)
    |> Enum.reduce("", fn thing, acc ->
      case thing do
        {range, id} ->
          new =  for _ <- range do
            id
          end
          |> Enum.join
          acc <> new
        range ->
          new = for _ <- range do
            "."
          end
          |> Enum.join
          acc <> new
      end
    end)
  end

  def get_max_index({files, _}) do
    files
    |> Enum.map(fn {range, _id} ->
      Range.size(range)
    end)
    |> Enum.sum()
    |> then(&(&1 - 1))
  end

  def checksum_range({range, file_id}) do
    for x <- range do
      x * file_id
    end
    |> Enum.sum
  end

  def part_1(input) do
    input
    |> parse_disk_map()
    |> refragment()
    |> Enum.map(&checksum_range/1)
    |> Enum.sum
  end

  @doc """
  Defragment the diskmap by:

  Attempt to move each file exactly once in order of decreasing file ID number starting with the file with the highest file ID number.
  If there is no span of free space to the left of a file that is large enough to fit the file, the file does not move.

  Assumes that files is already appropriately sorted right-to-left (we'll only touch each once, so we don't have to worry about maintaining sort)
  Assumes that free space is sorted left-to-right
  """
  def defrag({files, free_spaces}) do
    Enum.reduce(files, {[], free_spaces}, fn {file_range, file_id} = file, {current_files, current_free_space} = _acc ->
      # IO.puts("\n\n==================================")
      # IO.puts("trying file #{inspect(file)}")
      # IO.puts(inspect(acc))
      # IO.puts(print_disk_map(acc))
      file_size = Range.size(file_range)
      # available_space = Enum.find(current_free_space, fn free_range ->
      #   Range.size(free_range) >= file_size
      # end)


      valid_insertion_ranges =
        Enum.filter(current_free_space, fn _..fs_b = fs->
          file_start.._ = file_range
          (fs_b < file_start ) and Range.size(fs) >= file_size
        end )

      available_space = case valid_insertion_ranges do
        [] ->  nil
        _ -> hd(valid_insertion_ranges)
      end

      new_free_space = List.delete(current_free_space, available_space)

      cond do
        available_space == nil ->
          # IO.puts("not moving #{inspect(file)}")
          {[file | current_files], current_free_space}
        Range.size(available_space) == file_size ->
          # IO.puts("this hole #{inspect(available_space)} was meant for #{inspect(file)}")
          # IO.puts("he left behind #{inspect(file_range)}")

          new_free_space =
            [file_range | new_free_space]
            |> Enum.sort_by(fn a.._ -> a end)

          # IO.puts("I put that back in and now here's the new free_space #{inspect(new_free_space)}")


          {[{available_space, file_id} | current_files], new_free_space}
        Range.size(available_space) > file_size ->

          # IO.puts("this hole #{inspect(available_space)} is too big for #{inspect(file)}")
          free_start..free_end = available_space
          moved_file_range = free_start..(free_start + file_size - 1)
          # IO.puts("#{inspect(file)} going to #{inspect(moved_file_range)}")
          remaining_free_space = (free_start + file_size)..free_end

          new_free_space =
            [file_range, remaining_free_space] ++ new_free_space
            |> Enum.sort_by(fn a.._ -> a end)

          # IO.puts("putting this guy #{inspect(remaining_free_space)} back")
          new_files = [{moved_file_range, file_id} | current_files]
          # IO.puts("here's the current free spaces: #{inspect(new_free_space)}")
          # insertion_point = Enum.find_index(new_free_space, fn a.._ ->
          #   a > free_end
          # end)
          # insertion_point = if(insertion_point, do: insertion_point, else: 0)
          # IO.puts("I think I will put him at #{insertion_point}")
          # new_free_space = List.insert_at(new_free_space, insertion_point, remaining_free_space)
          # IO.puts("which looks like #{inspect(new_free_space)}")
          {new_files, new_free_space}
        end

    end)
  end

  def part_2(input) do
    input
    |> parse_disk_map()
    |> defrag()
    |> then(fn {files, _} -> files end)
    |> Enum.map(&checksum_range/1)
    |> Enum.sum
  end
end
