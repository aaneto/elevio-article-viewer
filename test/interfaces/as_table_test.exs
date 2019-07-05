defmodule AsTableTest do
  use ExUnit.Case
  doctest AsTable

  test "test as table display of article" do
    article = %Elevio.Article {
      id: 2,
      title: "Need a hand?",
      status: "published",
      source: "custom",
      created_at: "2019-06-27T21:35:37Z",
      author: %Elevio.Author {
        name: "Safwan Kamarrudin",
        email: "safwan@elev.io"
      }
    }

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
    keyword_search = %Elevio.KeywordSearch {
      results: [
        %Elevio.KeywordResult {
          title: "BZZZZ",
          category_id: 1,
          id: 6
        },
        %Elevio.KeywordResult {
          title: "MOARR PAGES",
          category_id: 1,
          id: 5
        },
        %Elevio.KeywordResult {
          title: "Need a hand?",
          category_id: 1,
          id: 2
        },
        %Elevio.KeywordResult {
          title: "Another testing article",
          category_id: 1,
          id: 4
        }
      ]
    }

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
