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
