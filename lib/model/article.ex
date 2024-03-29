defmodule Elevio.ArticleJSON do
  @moduledoc """
  ArticleJSON is the JSON response of the server
  for articles, it merely contains a key 'article'
  with content attached to it.
  """
  @enforce_keys [:article]
  defstruct [:article]
end

defmodule Elevio.Article do
  @moduledoc """
  Article is the main struct for and article, responsible
  for deserializing and validating Article objects.
  """

  defstruct [
    :id,
    :title,
    :order,
    :notes,
    :access,
    :author,
    :status,
    :source,
    :keyword,
    :revision,
    :updated_at,
    :created_at,
    :smart_groups,
    :contributors,
    :translations,
    :access_groups,
    :access_emails,
    :external_id,
    :category_id,
    :editor_version,
    :access_domains,
    :last_publisher,
    :last_published_at
  ]

  def decode_from_text(text) do
    article_json_result =
      Poison.decode(text,
        as: %Elevio.ArticleJSON{
          article: %Elevio.Article{
            revision: %Elevio.Article{
              contributors: [%Elevio.Author{}],
              author: %Elevio.Author{},
              translations: [%Elevio.Translation{}]
            },
            author: %Elevio.Author{},
            contributors: [%Elevio.Author{}],
            translations: [%Elevio.Translation{}]
          }
        }
      )

    case article_json_result do
      {:ok, article_json} -> {:ok, article_json.article}
      _ -> {:error, :invalidjson}
    end
  end
end
