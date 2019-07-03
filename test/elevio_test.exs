defmodule ElevioTest do
  use ExUnit.Case
  doctest Elevio

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
end
