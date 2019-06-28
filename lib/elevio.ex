defmodule Elevio do
  @moduledoc """
  Documentation for Elevio.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elevio.hello()
      :world

  """
  def main(args \\ []) do
    case OptionParser.parse(args, strict: [keyword: :string]) do
      {[keyword: keyword_string], _, _} -> IO.puts "Has #{keyword_string}"
      _ -> IO.puts "where is args???"
    end
  end
end