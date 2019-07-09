defmodule ArticleTest do
  use ExUnit.Case, async: true

  doctest Elevio.Article
  alias Elevio.Article

  test "parse well formated article" do
    article_text = File.read!("test/res/article.json")
    article_option = Article.decode_from_text(article_text)

    assert :ok == elem(article_option, 0)
  end

  test "error on invalid article" do
    article_text = File.read!("test/res/invalid_json.json")
    article_option = Article.decode_from_text(article_text)

    assert {:error, :invalidjson} == article_option
  end
end
