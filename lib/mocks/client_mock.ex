defmodule Elevio.ClientMock do
  @moduledoc """
  The ClientMock is a Stub implementation of the Client
  to emulate state, it is used for testing and "offline"
  execution.
  """
  @behaviour Elevio.ClientBehaviour
  def get_article_by_id(auth, id) do
    body =
      case id do
        1 -> File.read!("test/res/article.json")
        2 -> File.read!("test/res/invalid_json.json")
        _ -> nil
      end

    case {auth, body} do
      {nil, _} ->
        {:error, {:invalidresponse, 401}}

      {_, nil} ->
        {:error, {:invalidresponse, 404}}

      {_, body} ->
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
    end
  end

  def get_articles_by_keyword(_auth, keyword, page, language_id) do
    body =
      case {keyword, page, language_id} do
        {"other", 1, "en"} -> File.read!("test/res/keyword_search_1.json")
        {"other", 2, "en"} -> File.read!("test/res/keyword_search_2.json")
        {"foo", 1, "en"} -> File.read!("test/res/keyword_search_3.json")
        _ -> nil
      end

    if is_nil(body) do
      {:error, {:invalidresponse, 404}}
    else
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: body
       }}
    end
  end

  def get_paginated_articles(auth, page_number) do
    body =
      case page_number do
        1 -> File.read!("test/res/all_articles_1.json")
        2 -> File.read!("test/res/all_articles_2.json")
        _ -> nil
      end

    case {auth, body} do
      {nil, _} ->
        {:error, {:invalidresponse, 401}}

      {_, nil} ->
        {:error, {:invalidresponse, 404}}

      {_, body} ->
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
    end
  end
end
