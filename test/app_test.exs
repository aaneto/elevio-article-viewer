defmodule AppTest do
  use ExUnit.Case
  doctest Elevio.App

  test "parse article correctly" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:ok, article} = Elevio.App.get_article_by_id(auth, 1)

    assert article.author.name == "Safwan Kamarrudin"
  end

  test "test client responded with 404" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:error, {:invalidresponse, 404}} = Elevio.App.get_article_by_id(auth, 17)
  end

  test "error parsing article without author" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:error, {:missingfield, :article, :author}} = Elevio.App.get_article_by_id(auth, 3)
  end

  test "error parsing translation with no id" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    {:error, {:missingfield, :translation, :id}} = Elevio.App.get_article_by_id(auth, 2)
  end
end
