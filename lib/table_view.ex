defmodule Elevio.TableView do
  @moduledoc """
  The TableView module is responsible for displaying a paginated view
  over any table

  The Table is displayed with ANSI escape characters and can represent
  any data that can be displayed as a key-value pair.
  """
  def search_by_keyword(auth, keyword, language, page, io \\ IO) do
    clear_screen(io)
    io.puts("Searching articles with keyword #{keyword}")

    articles_option = Elevio.App.get_articles_by_keyword(auth, keyword, page, language)
    io.puts(display_topic("Page", articles_option))

    prompt_topic(
      "page",
      fn new_page -> search_by_keyword(auth, keyword, language, new_page) end,
      io
    )
  end

  def search_by_id(auth, id, io \\ IO) do
    clear_screen(io)
    io.puts("Fetching article #{id}")

    display_article_option = Elevio.App.get_article_by_id(auth, id)
    io.puts(display_topic("id", display_article_option))
    prompt_topic("id", fn new_id -> search_by_id(auth, new_id) end, io)
  end

  def show_articles_paginated(auth, page_number, io \\ IO) do
    clear_screen(io)
    io.puts("Paginating all articles")

    show_articles_option = Elevio.App.get_paginated_articles(auth, page_number)
    io.puts(display_topic("Page", show_articles_option))
    prompt_topic("page", fn new_page -> show_articles_paginated(auth, new_page) end, io)
  end

  def display_topic(topic, as_table_data_option) do
    case as_table_data_option do
      {:ok, as_table_data} ->
        AsTable.as_table(as_table_data)

      {:error, {:invalidresponse, 401}} ->
        "Invalid Credentials. (401)"

      {:error, {:invalidresponse, 404}} ->
        "#{topic} not found. (404)"

      {:error, {:invalidresponse, status_code}} ->
        "Cannot display #{String.downcase(topic)}, server responded with #{status_code}"

      {:error, reason} ->
        "An unexpected error occurred: #{reason}"
    end
  end

  def handle_goto_id(next_display, goto_argument, io \\ IO) do
    trimmed_argument = String.trim(goto_argument)
    case Integer.parse(trimmed_argument) do
      :error ->
        io.puts("Could not parse page '#{trimmed_argument}'")

      {goto_id, _} ->
        next_display.(goto_id)
    end
  end

  def prompt_topic(topic, next_display, io \\ IO) do
    prompt_text = """
    e: exit,
    g #{topic}: goto new #{topic}
    """

    user_response = io.gets(prompt_text)

    case user_response do
      :eof -> io.puts("Received EOF, exitting.")
      {:error, reason} -> io.puts("An error occurred processing your input: #{reason}.")
      "g" <> goto_id -> handle_goto_id(next_display, goto_id, io)
      response -> io.puts("Received response '#{String.trim(response)}'. Exitting.")
    end
  end

  def clear_screen(io \\ IO) do
    io.write(IO.ANSI.clear())
    io.write(IO.ANSI.cursor(0, 0))
  end
end
