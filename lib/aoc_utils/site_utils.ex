defmodule AocUtils.SiteUtils do
  @moduledoc """
  Provides a few functions to interact in an automated fashion with the Advent of Code website. These
  will mostly be utilized by the "mix day" task now, although longer term I like the idea of being able
  to read the puzzles fully from the command line.

  Since Advent of Code puzzles are unique to each user, it's necessary to authenticate when making requests
  to the site. The current auth method on the AoC website is fairly simple - a Cookie for a session token
  is sent with each request.

  I'm currently authenticating to Advent of Code with Github, and it's not yet clear to me how these tokens
  get renewed. We're going to start simple and store a known good session token in a `.session_token` file,
  (which is gitignored) and see how that works. It may be necessary to update this token at some point, which
  for now would have to be a manual process of grabbing the token from a request made in the browser. It
  might be possible for us to update the stored token on the filesystem automatically, and it also might be
  possible to pop a Github auth window and capture the token from the command line, but we won't think that
  hard for the time being.
  """

  @session_token_filename "./.session_token"
  @aoc_site_base_url "https://adventofcode.com"

  @doc """
  Given a year and day, fetches the input text for that puzzle from adventofcode.com
  """
  def get_puzzle_input(day, year) do
    init_httpoison()

    session_token = load_session_token()

    # this should probably use HTTPoison.get instead, and handle the error case. the common failure
    # mode I expect would be when my session token expires... i'm not sure how long the lifetime on those
    # tokens is.
    HTTPoison.get!(
      puzzle_input_url(day, year),
      [
        {"Cookie", "session=#{session_token}"}
      ]
    ).body |> String.trim("\n")
  end

  @doc """
  Given a year and day, fetches the description text for that puzzle from adventofcode.com.
  This one may be a bit trickier since the description is not provided in full until you finish part 1.

  It might make sense to have a part 1 function and a part 2 function.

  After inspecting the HTML, it looks like the way things work is an <article> tag with the "day-desc" class. The second one
  is not returned to the user until after they've successfully completed part 1.
  """
  def get_puzzle_description(_day, _year) do
  # just a stub for now
  end

  def submit_puzzle_solution(_day, _year, _solution) do
  # just a stub for now
  end

  defp puzzle_input_url(day, year) do
    "#{@aoc_site_base_url}/#{year}/day/#{day}/input"
  end

  defp load_session_token() do
    File.read!(@session_token_filename)
  end

  defp init_httpoison() do
    # this is necessary for calling httpoison funcs from a mix task
    Application.ensure_all_started(:httpoison)
  end

end
