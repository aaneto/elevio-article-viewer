defmodule TableViewTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  doctest Elevio.TableView

  test "table view clears screen correctly" do
    expected_output = IO.ANSI.clear() <> IO.ANSI.cursor(0, 0)
    assert capture_io(fn -> Elevio.TableView.clear_screen() end) == expected_output
  end

  test "TableView 404 display" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    article_option = Elevio.App.get_article_by_id(auth, 117)
    article_display = Elevio.TableView.display_topic("Article", article_option)

    assert article_display == "Article not found. (404)"
  end

  test "TableView 401 display" do
    article_option = Elevio.App.get_article_by_id(nil, 117)
    article_display = Elevio.TableView.display_topic("Article", article_option)

    assert article_display == "Invalid Credentials. (401)"
  end
end
