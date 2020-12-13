defmodule Day12 do
  defmodule BoatState do
    defstruct position: {0, 0}, heading: "E", waypoint: {10, 1}
  end

  alias Day12.BoatState

  def process_instruction(
        %BoatState{position: start_pos, heading: start_heading},
        instruction_str
      ) do
    {instruction, value_str} = String.split_at(instruction_str, 1)
    value = String.to_integer(value_str)

    case instruction do
      "E" ->
        %BoatState{position: new_position(start_pos, "E", value), heading: start_heading}

      "W" ->
        %BoatState{position: new_position(start_pos, "W", value), heading: start_heading}

      "S" ->
        %BoatState{position: new_position(start_pos, "S", value), heading: start_heading}

      "N" ->
        %BoatState{position: new_position(start_pos, "N", value), heading: start_heading}

      "L" ->
        %BoatState{position: start_pos, heading: new_heading(start_heading, "L", value)}

      "R" ->
        %BoatState{position: start_pos, heading: new_heading(start_heading, "R", value)}

      "F" ->
        %BoatState{
          position: new_position(start_pos, start_heading, value),
          heading: start_heading
        }
    end
  end

  def new_heading(start_heading, direction, value) do
    turns = Integer.floor_div(value, 90)

    case direction do
      "L" -> left_turns(start_heading) |> Enum.take(turns + 1) |> List.last()
      "R" -> right_turns(start_heading) |> Enum.take(turns + 1) |> List.last()
    end
  end

  def right_turns(start) do
    Stream.iterate(start, fn heading ->
      case heading do
        "E" -> "S"
        "S" -> "W"
        "W" -> "N"
        "N" -> "E"
      end
    end)
  end

  def left_turns(start) do
    Stream.iterate(start, fn heading ->
      case heading do
        "E" -> "N"
        "N" -> "W"
        "W" -> "S"
        "S" -> "E"
      end
    end)
  end

  def new_position({start_x, start_y}, heading, distance) do
    case heading do
      "E" -> {start_x + distance, start_y}
      "W" -> {start_x - distance, start_y}
      "N" -> {start_x, start_y + distance}
      "S" -> {start_x, start_y - distance}
    end
  end

  def process_instruction_part_2(
        %BoatState{position: start_pos, heading: start_heading, waypoint: waypoint_pos} =
          boat_state,
        instruction_str
      ) do
    {instruction, value_str} = String.split_at(instruction_str, 1)
    value = String.to_integer(value_str)

    case instruction do
      "E" ->
        %BoatState{
          position: start_pos,
          heading: start_heading,
          waypoint: new_position(waypoint_pos, "E", value)
        }

      "W" ->
        %BoatState{
          position: start_pos,
          heading: start_heading,
          waypoint: new_position(waypoint_pos, "W", value)
        }

      "N" ->
        %BoatState{
          position: start_pos,
          heading: start_heading,
          waypoint: new_position(waypoint_pos, "N", value)
        }

      "S" ->
        %BoatState{
          position: start_pos,
          heading: start_heading,
          waypoint: new_position(waypoint_pos, "S", value)
        }

      "L" ->
        rotate_waypoint(boat_state, "L", value)

      "R" ->
        rotate_waypoint(boat_state, "R", value)

      "F" ->
        follow_waypoint(boat_state, value)
    end
  end

  def follow_waypoint(
        %BoatState{position: {p_x, p_y},
                   waypoint: {w_x, w_y} = waypoint,
                   heading: heading},
        follow_repetitions
      ) do
      new_pos = { p_x + (w_x * follow_repetitions),
                  p_y + (w_y * follow_repetitions) }

      %BoatState{position: new_pos, heading: heading, waypoint: waypoint}
  end

  def rotate_waypoint(
        %BoatState{position: position,
                   waypoint: {w_x, w_y},
                   heading: heading},
        direction,
        rotation) do

        new_waypoint =
        case direction do
          "L" -> case rotation do
            90 -> {-w_y, w_x}
            180 -> {-w_x, -w_y}
            270 -> {w_y, -w_x}
          end

          "R" -> case rotation do
            90 -> {w_y, -w_x}
            180 -> {-w_x, -w_y}
            270 -> {-w_y, w_x}
          end
        end

        %BoatState{waypoint: new_waypoint,
                   position: position,
                   heading: heading}
  end

  def manhattan_distance({x_1, y_1}, {x_2, y_2}) do
    abs(x_1 - x_2) + abs(y_1 - y_2)
  end

  def part_1(input) do
    boat_state =
      input
      |> Enum.reduce(%BoatState{}, fn instruction, boat_state ->
        process_instruction(boat_state, instruction)
      end)

    manhattan_distance({0, 0}, boat_state.position)
  end

  def part_2(input) do
    boat_state =
      input
      |> Enum.reduce(%BoatState{}, fn instruction, boat_state ->
        process_instruction_part_2(boat_state, instruction)
      end)

    manhattan_distance({0, 0}, boat_state.position)
  end
end
