defmodule TableViewTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Elevio.FakeIO
  alias Elevio.TableView

  doctest Elevio.TableView

  test "table view clears screen correctly" do
    expected_output = IO.ANSI.clear() <> IO.ANSI.cursor(0, 0)
    assert capture_io(fn -> TableView.clear_screen() end) == expected_output
  end

  test "TableView 404 display" do
    article_option = {:error, {:invalidresponse, 404}}
    article_display = TableView.display_topic("Article", article_option)

    assert article_display == "Article not found. (404)"
  end

  test "TableView 401 display" do
    article_option = {:error, {:invalidresponse, 401}}
    article_display = TableView.display_topic("Article", article_option)

    assert article_display == "Invalid Credentials. (401)"
  end

  test "TableView 500 display" do
    article_option = {:error, {:invalidresponse, 500}}
    article_display = TableView.display_topic("Article", article_option)

    assert article_display == "Cannot display article, server responded with 500"
  end

  test "TableView unknow error display" do
    article_option = {:error, :cannotdecode}
    article_display = TableView.display_topic("Article", article_option)

    assert article_display == "An unexpected error occurred: #{:cannotdecode}"
  end

  test "TableView article display" do
    article = %Elevio.Article{
      revision: %Elevio.Article{
        author: %Elevio.Author{
          name: "Adilson",
          email: "almeidneto@gmail.com"
        },
        contributors: [],
        translations: []
      },
      author: %Elevio.Author{
        name: "Adilson",
        email: "almeidneto@gmail.com"
      },
      contributors: [],
      translations: []
    }

    article_display = TableView.display_topic("Article", {:ok, article})

    assert AsTable.as_table(article) == article_display
  end

  test "TableView prompt received eof" do
    FakeIO.start_io(:eof)
    TableView.prompt_topic("Article", fn id -> id end, FakeIO)

    assert FakeIO.get_input() == "Received EOF, exitting.\n"
  end

  test "TableView prompt erroed" do
    FakeIO.start_io({:error, :absurderror})
    TableView.prompt_topic("Article", fn id -> id end, FakeIO)

    assert FakeIO.get_input() == "An error occurred processing your input: absurderror.\n"
  end

  test "TableView prompt exit" do
    FakeIO.start_io("e")
    TableView.prompt_topic("Article", fn id -> id end, FakeIO)

    assert FakeIO.get_input() == "Received response 'e'. Exitting.\n"
  end

  test "TableView prompt go to invalid id" do
    FakeIO.start_io("g falafel")
    TableView.prompt_topic("Article", fn id -> id end, FakeIO)

    assert FakeIO.get_input() == "Could not parse page 'falafel'\n"
  end

  test "TableView prompt go to valid id" do
    FakeIO.start_io("g 10")
    # Send the parsed ID to FakeIO for further inspection
    TableView.prompt_topic("Article", fn id -> FakeIO.puts("#{id}") end, FakeIO)

    assert FakeIO.get_input() == "10\n"
  end

  # The tests below are integration tests

  test "Search by id and exit" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    FakeIO.start_io("e")
    TableView.search_by_id(auth, 1, FakeIO)

    clear_screen_ansi = "\e[2J\e[0;0H"

    application_output = """
    #{clear_screen_ansi}Fetching article 1
    ID: 1
    Title: gregr
    Status: published
    Source: custom
    Author Name: Safwan Kamarrudin
    Author Email: safwan@elev.io
    Created @: 2019-06-27T21:35:37Z

    Received response 'e'. Exitting.
    """

    assert FakeIO.get_input() == application_output
  end

  test "Search by keyword and exit" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    FakeIO.start_io("e")
    TableView.search_by_keyword(auth, "other", "en", 1, FakeIO)

    clear_screen_ansi = "\e[2J\e[0;0H"

    application_output = """
    #{clear_screen_ansi}Searching articles with keyword other
    Displaying page 1 out of 2

    Title: BZZZZ
    Category ID: 1
    ID: 6

    -----------
    Title: MOARR PAGES
    Category ID: 1
    ID: 5

    -----------
    Title: Need a hand?
    Category ID: 1
    ID: 2

    -----------
    Title: Another testing article
    Category ID: 1
    ID: 4

    Received response 'e'. Exitting.
    """

    assert FakeIO.get_input() == application_output
  end

  test "Show all and exit" do
    auth = %Elevio.Auth{api_key: nil, token: nil}
    FakeIO.start_io("e")
    TableView.show_articles_paginated(auth, 1, FakeIO)

    clear_screen_ansi = "\e[2J\e[0;0H"

    application_output = """
    #{clear_screen_ansi}Paginating all articles
    Displaying page 1 out of 2

    Title: gregr
    Id: 1
    Status: published

    -----------
    Title: Need a hand?
    Id: 2
    Status: published

    -----------
    Title: My testing article
    Id: 3
    Status: published

    -----------
    Title: Another testing article
    Id: 4
    Status: published

    Received response 'e'. Exitting.
    """

    assert FakeIO.get_input() == application_output
  end
end
