defmodule Elevio.PaginatedArticles do
  @moduledoc """
  The PaginatedArticles struct holds information
  about a "Search All" action on the Elevio API,
  all available articles are returned in a paginated
  fashion.
  """
  defstruct [
    :articles,
    :page_size,
    :page_number,
    :total_pages,
    :total_entries
  ]

  def decode_from_text(text) do
    Poison.decode(text,
      as: %Elevio.PaginatedArticles{
        articles: [
          %Elevio.Article{
            translations: [%Elevio.Translation{}]
          }
        ]
      }
    )
  end
end

defmodule Elevio.PaginatedArticle do
  @moduledoc """
  The PaginatedArticle is a paginated version
  of an article. This struct is similar to a full
  article but diverges on a few required fields.
  """
  defstruct [
    :id,
    :title,
    :order,
    :notes,
    :status,
    :access,
    :source,
    :keywords,
    :updated_at,
    :external_id,
    :category_id,
    :smart_groups,
    :has_revision,
    :translations,
    :access_emails,
    :access_domains,
    :article_groups,
    :editor_version,
    :revision_status,
    :revision_status,
    :subcategory_groups
  ]
end
