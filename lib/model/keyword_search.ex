defmodule Elevio.KeywordResult do
  @moduledoc """
  The KeywordResult is a single article
  result on a keyword search on the Elevio
  API.
  """
  @derive [Poison.Encoder]
  defstruct [
    :category_id,
    :id,
    :title
  ]
end

defmodule Elevio.KeywordSearch do
  @moduledoc """
  The KeywordSearch struct represents
  a search by keyword on the Elevio API,
  with important paginating metadata.
  """
  @derive [Poison.Encoder]
  defstruct [
    :count,
    :currentPage,
    :queryTerm,
    :results,
    :totalPages,
    :totalResults
  ]

  def decode_from_text(text) do
    result =
      Poison.decode!(text,
        as: %Elevio.KeywordSearch{
          results: [%Elevio.KeywordResult{}]
        }
      )

    {:ok, result}
  end
end
