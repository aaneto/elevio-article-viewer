defmodule ElevioTest do
  use ExUnit.Case
  doctest Elevio

  alias Elevio.FakeIO

  test "parse keyword cli argument" do
    options = Elevio.parseArguments(["--keyword", "key"])

    assert options == [keyword: "key"]
  end

  test "parse id cli argument" do
    options = Elevio.parseArguments(["--id", "2"])

    assert options == [id: "2"]
  end

  test "parse id and keyword cli arguments" do
    options = Elevio.parseArguments(["--id", "2", "--keyword", "key"])

    assert options == [id: "2", keyword: "key"]
  end

  test "ignore invalid cli argument" do
    mispelled_keyword = Elevio.parseArguments(["--keywrd", "foo"])
    incomplete_id = Elevio.parseArguments(["--id"])

    assert mispelled_keyword == []
    assert incomplete_id == []
  end

  # Integration Tests

  test "user inputed keyword and id" do
    FakeIO.start_io("e")
    Elevio.main(["--id", "1", "--keyword", "key"], FakeIO)

    assert FakeIO.get_input() == Elevio.getHelpMenu() <> "\n"
  end

  test "user inputed invalid id" do
    FakeIO.start_io("e")
    Elevio.main(["--id", "foobar"], FakeIO)

    assert FakeIO.get_input() == "Invalid ID. Exitting.\n"
  end

  test "user searched by keyword without providing language" do
    FakeIO.start_io("e")
    Elevio.main(["--keyword", "foobar"], FakeIO)

    assert FakeIO.get_input() == "Please provide a language for the keyword search.\n"
  end

  test "user provided language without providing keyword" do
    FakeIO.start_io("e")
    Elevio.main(["--language", "en"], FakeIO)

    assert FakeIO.get_input() == "Cannot query articles by languague, please provide a keyword.\n"
  end

  test "user searched by id" do
    auth = %Elevio.Auth{
      api_key: nil,
      token: nil
    }

    FakeIO.start_io("e")
    Elevio.main(["--id", "1"], FakeIO)

    main_output = FakeIO.get_input()
    FakeIO.reset_captured_input()

    Elevio.TableView.search_by_id(auth, 1, FakeIO)
    id_search_output = FakeIO.get_input()

    assert id_search_output == main_output
  end

  test "user searched by keyword" do
    auth = %Elevio.Auth{
      api_key: nil,
      token: nil
    }

    FakeIO.start_io("e")
    Elevio.main(["--keyword", "other", "--language", "en"], FakeIO)

    main_output = FakeIO.get_input()
    FakeIO.reset_captured_input()

    Elevio.TableView.search_by_keyword(auth, "other", "en", 1, FakeIO)
    keyword_search_output = FakeIO.get_input()

    assert keyword_search_output == main_output
  end

  test "user requested all articles" do
    auth = %Elevio.Auth{
      api_key: nil,
      token: nil
    }

    FakeIO.start_io("e")
    Elevio.main(["--all"], FakeIO)

    main_output = FakeIO.get_input()
    FakeIO.reset_captured_input()

    Elevio.TableView.show_articles_paginated(auth, 1, FakeIO)
    paginated_output = FakeIO.get_input()

    assert paginated_output == main_output
  end
end
