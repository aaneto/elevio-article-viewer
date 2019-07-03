defmodule Elevio.App do
  @moduledoc """
  The App module is a wrapper to the Elevio Client,
  the main reason of this wrapping is separating IO
  from logic, making the App itself "mockable".
  """
  @client Application.get_env(:elevio, :elevio_client)

  def get_article_by_id(auth, id) do
    case @client.get_article_by_id(auth, id) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Elevio.Article.decode_from_text(body)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:invalidresponse, code}}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_articles_by_keyword(auth, keyword, page, language_id) do
    case @client.get_articles_by_keyword(auth, keyword, page, language_id) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Elevio.KeywordSearch.decode_from_text(body)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:invalidresponse, code}}

      {:error, error} ->
        {:error, error}
    end
  end
end
