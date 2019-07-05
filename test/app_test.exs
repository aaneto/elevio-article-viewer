defmodule AppTest do
  use ExUnit.Case
  doctest Elevio.App

  test "parse article correctly" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:ok, article} = Elevio.App.get_article_by_id(auth, 1)

    assert article.author.name == "Safwan Kamarrudin"
  end

  test "get article by id responded with 404" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:error, {:invalidresponse, 404}} = Elevio.App.get_article_by_id(auth, 17)
  end

  test "get articles by keyword responded with 404" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:error, {:invalidresponse, 404}} = Elevio.App.get_articles_by_keyword(auth, "bla", 1, "pt")
  end

  test "get articles by keyword correctly" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:ok, keyword_search} = Elevio.App.get_articles_by_keyword(auth, "other", 1, "en")

    assert Enum.at(keyword_search.results, 0).title == "BZZZZ"
    assert length(keyword_search.results) == keyword_search.count
  end
end
