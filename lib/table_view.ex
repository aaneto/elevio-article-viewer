defmodule Elevio.TableView do
  @moduledoc """
  The TableView module is responsible for displaying a paginated view
  over any table

  The Table is displayed with ANSI escape characters and can represent
  any data that can be displayed as a key-value pair.
  """
  def search_by_keyword(auth, keyword, page) do
    clear_screen()
    IO.puts("Searching articles with keyword #{keyword}")

    display_keyword_search(auth, keyword, page)

    case prompt_topic("page") do
      {:ok, :exitcmd} -> IO.puts("Exitting. ")
      {:error, {:parseerror, text}} -> IO.puts("Could not parse page #{text}")
      {:ok, new_page} -> search_by_keyword(auth, keyword, new_page)
    end
  end

  def display_keyword_search(auth, keyword, page) do
    case Elevio.App.get_articles_by_keyword(auth, keyword, page, "en") do
      {:ok, search} ->
        IO.puts(AsTable.as_table(search))
        IO.puts("\nDisplaying page #{search.currentPage} out of #{search.totalPages}")

      {:error, {:invalidresponse, status_code}} ->
        IO.puts("Could not fetch page, server responded with: #{status_code}")

      {:error, error} ->
        IO.puts("An unexpected error occured: #{error}")
    end
  end

  def search_by_id(auth, id) do
    clear_screen()
    IO.puts("Fetching article #{id}")

    display_single_article(auth, id)

    case prompt_topic("article id") do
      {:ok, :exitcmd} -> IO.puts("Exitting. ")
      {:error, {:parseerror, id}} -> IO.puts("Could not parse id #{id}")
      {:ok, new_id} -> search_by_id(auth, new_id)
    end
  end

  def display_single_article(auth, id) do
    case Elevio.App.get_article_by_id(auth, id) do
      {:ok, article} ->
        IO.puts(AsTable.as_table(article))

      {:error, {:invalidresponse, 401}} ->
        IO.puts("Invalid credentials. (401)")

      {:error, {:invalidresponse, 404}} ->
        IO.puts("Article does not exist (404).")

      {:error, {:invalidresponse, status_code}} ->
        IO.puts("Cannot display article, server responded with #{status_code}")

      {:error, {:missingfield, where, field}} ->
        IO.puts(~s(Error deserializing "#{field}" for "#{where}"))

      {:error, reason} ->
        IO.puts("An unexpected error occured: #{reason}")
    end
  end

  def show_articles_paginated(auth, page_number) do
    clear_screen()
    IO.puts("Paginating all articles")

    display_paginated_articles(auth, page_number)

    case prompt_topic("page") do
      {:ok, :exitcmd} -> IO.puts("Exitting. ")
      {:error, {:parseerror, text}} -> IO.puts("Could not parse page #{text}")
      {:ok, new_page} -> show_articles_paginated(auth, new_page)
    end
  end

  def display_paginated_articles(auth, page_number) do
    case Elevio.App.get_paginated_articles(auth, page_number) do
      {:ok, paginated_articles} ->
        IO.puts(AsTable.as_table(paginated_articles))

        IO.puts(
          "\nDisplaying page #{paginated_articles.page_number} out of #{
            paginated_articles.total_pages
          }"
        )

      {:error, {:invalidresponse, 401}} ->
        IO.puts("Invalid credentials. (401)")

      {:error, {:invalidresponse, 404}} ->
        IO.puts("Article does not exist (404).")

      {:error, {:invalidresponse, status_code}} ->
        IO.puts("Cannot display article, server responded with #{status_code}")

      {:error, {:missingfield, where, field}} ->
        IO.puts(~s(Error deserializing "#{field}" for "#{where}"))

      {:error, reason} ->
        IO.puts("An unexpected error occured: #{reason}")
    end
  end

  def prompt_topic(topic) do
    instructions = """
    e: exit,
    g #{topic}: goto new #{topic}
    """

    prompt_text = "\n" <> instructions <> "\n"

    case prompt_text |> IO.gets() |> String.trim() do
      "g" <> new_topic_id_str ->
        case Integer.parse(new_topic_id_str) do
          :error ->
            {:error, {:parseerror, new_topic_id_str}}

          {new_topic_id, _} ->
            {:ok, new_topic_id}
        end

      _ ->
        {:ok, :exitcmd}
    end
  end

  def clear_screen do
    IO.write(IO.ANSI.clear())
    IO.write(IO.ANSI.cursor(0, 0))
  end
end
