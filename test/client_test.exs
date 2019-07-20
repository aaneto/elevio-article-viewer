defmodule ClientTest do
  use ExUnit.Case, async: true

  doctest Elevio.Client
  alias Elevio.Client

  @tag :skip
  test "get a 200 response searching paginated articles" do
    auth = %Elevio.Auth{
      api_key: System.get_env("API_KEY"),
      token: System.get_env("TOKEN")
    }

    article_option = Client.get_paginated_articles(auth, 1)
    {:ok, %HTTPoison.Response{status_code: status_code}} = article_option

    assert status_code == 200
  end

  @tag :skip
  test "get a 200 response searching articles by keyword" do
    auth = %Elevio.Auth{
      api_key: System.get_env("API_KEY"),
      token: System.get_env("TOKEN")
    }

    keyword_search = Client.get_articles_by_keyword(auth, "other", 1, "en")
    {:ok, %HTTPoison.Response{status_code: status_code}} = keyword_search

    assert status_code == 200
  end

  @tag :skip
  test "get a 200 response searching articles by id" do
    auth = %Elevio.Auth{
      api_key: System.get_env("API_KEY"),
      token: System.get_env("TOKEN")
    }

    keyword_search = Client.get_article_by_id(auth, 1)
    {:ok, %HTTPoison.Response{status_code: status_code}} = keyword_search

    assert status_code == 200
  end
end
