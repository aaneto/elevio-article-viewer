defmodule Elevio.ClientMock do
  @moduledoc """
  The ClientMock is a Stub implementation of the Client
  to emulate state, it is used for testing and "offline"
  execution.
  """
  @behaviour Elevio.ClientBehaviour
  def get_article_by_id(_auth, id) do
    body =
      case id do
        0 -> File.read!("test/res/article.json")
        1 -> File.read!("test/res/article_with_revision.json")
        2 -> File.read!("test/res/article_translation_no_id.json")
        3 -> File.read!("test/res/article_without_author.json")
        _ -> nil
      end

    if not is_nil(body) do
      {
        :ok,
        %HTTPoison.Response{
          status_code: 200,
          body: body
        }
      }
    else
      {
        :error,
        {:invalidresponse, 404}
      }
    end
  end

  def get_articles_by_keyword(_auth, _keyword, _page, _language_id) do
    {
      :error,
      {:invalidresponse, 404}
    }
  end
end
