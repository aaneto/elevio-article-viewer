defmodule Elevio.ClientBehaviour do
  @moduledoc """
  The ClientBehaviour Behaviour is the main definition
  on how a Elevio Client should be interacted with, this is
  the basis for Client IO decoupling.
  """
  @callback get_article_by_id(%Elevio.Auth{}, number) ::
              {:ok, %HTTPoison.Response{}} | {:error, term}
  @callback get_articles_by_keyword(%Elevio.Auth{}, String.t(), String.t(), String.t()) ::
              {:ok, %HTTPoison.Response{}} | {:error, term}
  @callback get_paginated_articles(%Elevio.Auth{}, number) ::
              {:ok, %HTTPoison.Response{}} | {:error, term}
end

defmodule Elevio.Client do
  @behaviour Elevio.ClientBehaviour
  @moduledoc """
  The API module is responsible for communicating with the API.

  In practice, this means getting articles, filtering and
  paginating them.

  """
  def fetch_resource(auth, resource) do
    HTTPoison.start()
    base_url = "https://api.elevio-staging.com/v1/"

    headers = [
      Authorization: "Bearer #{auth.token}",
      Accept: "Application/json; Charset=utf-8",
      "x-api-key": auth.api_key
    ]

    HTTPoison.get(base_url <> resource, headers)
  end

  def get_article_by_id(auth, id) do
    Elevio.Client.fetch_resource(auth, "articles/#{id}")
  end

  def get_articles_by_keyword(auth, keyword, page, language_id) do
    url_extension = "search/#{language_id}?query=#{keyword}&rows=4&page=#{page}"

    Elevio.Client.fetch_resource(auth, url_extension)
  end

  def get_paginated_articles(auth, page_number) do
    Elevio.Client.fetch_resource(auth, "articles?page_size=4&page_number=#{page_number}")
  end
end
