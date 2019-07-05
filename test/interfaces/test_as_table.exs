defmodule AsTableTest do
  use ExUnit.Case
  doctest AsTable

  test "test as table display of article" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:ok, article} = Elevio.App.get_article_by_id(auth, 1)

    article_string = """
    Id: 2
    Title: Need a hand?
    Status: published
    Source: custom
    Author.name: Safwan Kamarrudin
    Author.email: safwan@elev.io
    Created @: 2019-06-27T21:35:37Z
    """
    # We need to append a \n to compensante for multistring formattting
    assert AsTable.as_table(article) <> "\n" == article_string
  end

  test "test as table display of keyword search" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:ok, keyword_search} = Elevio.App.get_articles_by_keyword(auth, "other", 1, "en")

    article_string = """

    title: BZZZZ
    category_id: 1
    id: 6
    -----------

    title: MOARR PAGES
    category_id: 1
    id: 5
    -----------

    title: Need a hand?
    category_id: 1
    id: 2
    -----------

    title: Another testing article
    category_id: 1
    id: 4
    """
    # We need to append a \n to compensante for multistring formattting
    assert AsTable.as_table(keyword_search) <> "\n" == article_string
  end
end
