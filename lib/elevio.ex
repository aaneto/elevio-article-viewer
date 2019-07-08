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
  def main(args \\ [], io \\ IO) do
    args
    |> parse_arguments
    |> create_table_view(io)
  end

  def parse_arguments(args) do
    options = [all: :boolean, keyword: :string, id: :string, language: :string]
    {table_view_options, _, _} = OptionParser.parse(args, strict: options)
    table_view_options
  end

  def get_help_menu do
    """
    Elevio CLI Client

    Query for Elevio articles on your account by keyword,
    id or pagination.

    USAGE:
      elevio --all
      elevio --id ID
      elevio --keyword KEYWORD --language LANGUAGE_ID
    """
  end

  def create_table_view(options, io \\ IO) do
    auth = %Elevio.Auth{
      token: System.get_env("TOKEN"),
      api_key: System.get_env("API_KEY")
    }

    case Enum.sort(options) do
      [keyword: keyword, language: language] ->
        Elevio.TableView.search_by_keyword(auth, keyword, language, 1, io)

      [language: _] ->
        io.puts("Cannot query articles by languague, please provide a keyword.")

      [keyword: _] ->
        io.puts("Please provide a language for the keyword search.")

      [id: id] ->
        case Integer.parse(id) do
          {num, _} -> Elevio.TableView.search_by_id(auth, num, io)
          :error -> io.puts("Invalid ID. Exitting.")
        end

      [all: true] ->
        Elevio.TableView.show_articles_paginated(auth, 1, io)

      _ ->
        io.puts(get_help_menu())
    end
  end
end
