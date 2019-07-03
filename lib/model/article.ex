defmodule Elevio.ArticleJSON do
  @moduledoc """
  ArticleJSON is the JSON response of the server
  for articles, it merely contains a key 'article'
  with content attached to it.
  """
  @derive [Poison.Encoder]
  @enforce_keys [:article]
  defstruct [:article]
end

defmodule Elevio.Article do
  @moduledoc """
  Article is the main struct for and article, responsible
  for deserializing and validating Article objects.
  """

  @derive [Poison.Encoder]
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

  def find_missing_fields(article) do
    required_fields = [
      :id,
      :order,
      :author,
      :source,
      :access,
      :status,
      :updated_at,
      :created_at,
      :translations,
      :category_id,
      :contributors,
      :editor_version
    ]

    case Enum.find(required_fields, fn field -> is_nil(Map.get(article, field)) end) do
      nil -> {:ok, article}
      field -> {:error, {:missingfield, :article, field}}
    end
  end

  def validate(article) do
    with {:ok, _} <- Elevio.Article.find_missing_fields(article),
         {:ok, _} <- Elevio.Author.find_missing_fields(article.author),
         {:ok, _} <- Elevio.Translation.find_missing_fields(article.translations),
         do: {:ok, article}
  end

  def decode_from_text(text) do
    result =
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

    case result do
      {:ok, result} -> validate(result.article)
      error -> error
    end
  end
end
