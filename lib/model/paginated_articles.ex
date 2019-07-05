defmodule Elevio.PaginatedArticles do
  @moduledoc """
  The PaginatedArticles struct holds information
  about a "Search All" action on the Elevio API,
  all available articles are returned in a paginated
  fashion.
  """
  defstruct [
    :total_pages,
    :total_entries,
    :page_size,
    :page_number,
    :articles
  ]

  def decode_from_text(text) do
    Poison.decode(text,
      as: %Elevio.PaginatedArticles{
        articles: [%Elevio.Article{}]
      }
    )
  end
end
