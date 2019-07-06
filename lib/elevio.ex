defmodule Elevio do
  @moduledoc """
  Elevio-CLI is a tool for visualizing Elevio API endpoints.

  As this is a programming test, this CLI only displays Elevio
  articles.
  """

  @doc """
  Main application entry point.


  ## Usage
  ```elixir
  elevio articles [--id ID] [--keyword KEYWORD]
  ```

  """
  def main(args \\ []) do
    args
    |> parseArguments
    |> createTableView
  end

  def parseArguments(args) do
    options = [all: :boolean, keyword: :string, id: :string, language: :string]
    {table_view_options, _, _} = OptionParser.parse(args, strict: options)
    table_view_options
  end

  def createTableView(options) do
    auth = %Elevio.Auth{
      token: System.get_env("TOKEN"),
      api_key: System.get_env("API_KEY")
    }

    help_menu = """
    Elevio CLI Client

    Query for Elevio articles on your account by keyword,
    id or pagination.

    USAGE:
      elevio --all
      elevio --id ID
      elevio --keyword KEYWORD --language LANGUAGE_ID
    """

    case options do
      [keyword: keyword, language: language] ->
        Elevio.TableView.search_by_keyword(auth, keyword, language, 1)

      [language: language, keyword: keyword] ->
        Elevio.TableView.search_by_keyword(auth, keyword, language, 1)

      [language: _] ->
        IO.puts("Cannot query articles by languague_id, please provide a keyword.")

      [keyword: _] ->
        IO.puts("Please provide a language_id for the keyword search.")

      [id: id] ->
        case Integer.parse(id) do
          {num, _} -> Elevio.TableView.search_by_id(auth, num)
          :error -> IO.puts("Invalid ID. Exitting.")
        end

      [all: true] ->
        Elevio.TableView.show_articles_paginated(auth, 1)

      _ ->
        IO.puts(help_menu)
    end
  end
end
