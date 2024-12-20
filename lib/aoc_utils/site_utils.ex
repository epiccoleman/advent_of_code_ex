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
  @user_agent "https://github.com/epiccoleman/advent_of_code_ex by eric@epiccoleman.com"

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
    ).body
    |> String.trim("\n")
  end

  @doc """
  Given a year and day, fetches the description text for that puzzle from adventofcode.com, and converts it to markdown.
  """
  def get_puzzle_description_pt_1(day, year) do
    init_httpoison()

    session_token = load_session_token()

    html =
      HTTPoison.get!(
        puzzle_url(day, year),
        [
          {"Cookie", "session=#{session_token}"}
        ]
      ).body

    {:ok, doc} = Floki.parse_document(html)

    article_html =
      Floki.find(doc, "article")
      |> Enum.at(0)
      |> Floki.raw_html()

    {:ok, md} = Pandex.html_to_gfm(article_html)

    md
  end

  def get_puzzle_description_pt_2(day, year) do
    init_httpoison()

    session_token = load_session_token()

    html =
      HTTPoison.get!(
        puzzle_url(day, year),
        [
          {"Cookie", "session=#{session_token}"}
        ]
      ).body

    {:ok, doc} = Floki.parse_document(html)

    article_html =
      Floki.find(doc, "article")
      |> Enum.at(1)
      |> Floki.raw_html()

    {:ok, md} = Pandex.html_to_gfm(article_html)

    md
  end

  @doc """
  Submit an answer for Day / Year / Part
  """
  def submit_puzzle_solution(day, year, level, solution) do
    init_httpoison()

    url = puzzle_submit_url(day, year)
    body = "level=#{level}&answer=#{solution}"
    headers = [{"Content-Type", "application/x-www-form-urlencoded"} | headers()]

    response = HTTPoison.post!(url, body, headers)

    if response.status_code != 200 do
      throw("Failed to submit with status: #{response.status_code}")
    end

    {:ok, doc} = Floki.parse_document(response.body)

    Floki.find(doc, "article > p") |> Floki.text()
  end

  defp puzzle_input_url(day, year) do
    "#{@aoc_site_base_url}/#{year}/day/#{day}/input"
  end

  defp puzzle_submit_url(day, year) do
    "#{@aoc_site_base_url}/#{year}/day/#{day}/answer"
  end

  defp puzzle_url(day, year) do
    "#{@aoc_site_base_url}/#{year}/day/#{day}"
  end

  defp headers() do
    session_token = load_session_token()

    [
      {"User-Agent", @user_agent},
      {"Cookie", "session=#{session_token}"}
    ]
  end

  def load_session_token() do
    File.read!(@session_token_filename)
  end

  defp init_httpoison() do
    # this is necessary for calling httpoison funcs from a mix task
    Application.ensure_all_started(:httpoison)
  end
end
