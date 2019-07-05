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
    options = [keyword: :string, id: :string]
    {table_view_options, _, _} = OptionParser.parse(args, strict: options)
    table_view_options
  end

  def createTableView(options) do
    auth = %Elevio.Auth{
      token: System.get_env("TOKEN"),
      api_key: System.get_env("API_KEY")
    }

    case options do
      [keyword: keyword] ->
        Elevio.TableView.search_by_keyword(auth, keyword, 1)

      [id: id] ->
        case Integer.parse(id) do
          {num, _} -> Elevio.TableView.search_by_id(auth, num)
          :error -> IO.puts("Invalid ID. Exitting.")
        end

      [] ->
        Elevio.TableView.show_articles_paginated(auth, 1)

      _ ->
        IO.puts("You cannot view by id AND keyword.")
    end
  end
end
