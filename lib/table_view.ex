defmodule TableView do
  @moduledoc """
  The TableView module is responsible for displaying a paginated view
  over any table

  The Table is displayed with ANSI escape characters and can represent
  any data that can be displayed as a key-value pair.
  """
  def search_by_keyword(auth, keyword, page) do
    TableView.clear_screen()
    IO.puts("Searching articles with keyword #{keyword}")

    case Elevio.App.get_articles_by_keyword(auth, keyword, page, "en") do
      {:ok, search} ->
        IO.puts(AsTable.as_table(search))
        IO.puts("\nDisplaying page #{search.currentPage} out of #{search.totalPages}")

      {:error, {:invalidresponse, status_code}} ->
        IO.puts("Could not fetch page, server responded with: #{status_code}")

      {:error, error} ->
        IO.puts("An unexpected error occured: #{error}")
    end

    instructions =
      Enum.join(
        [
          "e: exit",
          "n: next",
          "p: previous",
          "g $id: goto id",
          "k $keyword: change keyword"
        ],
        "\n"
      )

    prompt_text = "\n" <> instructions <> "\n"

    case prompt_text |> IO.gets() |> String.trim() do
      "n" <> _ ->
        search_by_keyword(auth, keyword, page + 1)

      "p" <> _ ->
        search_by_keyword(auth, keyword, page - 1)

      "g" <> new_page ->
        case Integer.parse(new_page) do
          :error ->
            IO.puts("Could not parse Goto ID: #{new_page}.")
            search_by_keyword(auth, keyword, page)

          {num_page, _} ->
            search_by_keyword(auth, keyword, num_page)
        end

      "k" <> new_keyword ->
        search_by_keyword(auth, String.trim(new_keyword), 1)

      _ ->
        IO.puts("Exitting.")
    end
  end

  def search_by_id(auth, id) do
    TableView.clear_screen()
    IO.puts("Fetching article #{id}")
  end

  def show_all do
    TableView.clear_screen()
    IO.puts("Showing All")
  end

  def clear_screen do
    IO.write(IO.ANSI.clear())
    IO.write(IO.ANSI.cursor(0, 0))
  end
end
