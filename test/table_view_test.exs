defmodule TableViewTest do
    use ExUnit.Case
    import ExUnit.CaptureIO

    doctest Elevio.TableView

    test "table view clears screen correctly" do
      expected_output = IO.ANSI.clear() <> IO.ANSI.cursor(0, 0)
      assert capture_io(fn() -> Elevio.TableView.clear_screen end) == expected_output
    end

    test "table article 404 display" do
      auth = %Elevio.Auth{api_key: nil, token: nil}
      expected_output = "Article does not exist (404).\n"
      assert capture_io(fn() ->
        Elevio.TableView.display_single_article(auth, 10)
      end) == expected_output
    end

    test "table article standard display" do
      auth = %Elevio.Auth{api_key: nil, token: nil}
      valid_id = 0
      {:ok, article} = Elevio.App.get_article_by_id(auth, valid_id)

      assert capture_io(fn() ->
        Elevio.TableView.display_single_article(auth, valid_id)
      end) == AsTable.as_table(article) <> "\n"
    end
  end
