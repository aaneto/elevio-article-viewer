defmodule AppTest do
  use ExUnit.Case
  doctest Elevio.App

  test "parse article correctly" do
    auth = %Elevio.Auth{
      token: "token",
      api_key: "api_key"
    }

    {:ok, article} = Elevio.App.get_article_by_id(auth, 1)

    assert article.author.name == "Safwan Kamarrudin"
  end

  test "error parsing article without author" do
    auth = %Elevio.Auth{
      token: "token",
      api_key: "api_key"
    }

    {:error, {:missingfield, :article, :author}} = Elevio.App.get_article_by_id(auth, 3)
  end

  test "error parsing translation with no id" do
    auth = %Elevio.Auth{
      token: "token",
      api_key: "api_key"
    }

    {:error, {:missingfield, :translation, :id}} = Elevio.App.get_article_by_id(auth, 2)
  end
end