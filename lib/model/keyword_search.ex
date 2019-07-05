defmodule Elevio.KeywordResult do
  @moduledoc """
  The KeywordResult is a single article
  result on a keyword search on the Elevio
  API.
  """
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
  defstruct [
    :count,
    :currentPage,
    :queryTerm,
    :results,
    :totalPages,
    :totalResults
  ]

  def decode_from_text(text) do
    Poison.decode(text,
      as: %Elevio.KeywordSearch{
        results: [%Elevio.KeywordResult{}]
      }
    )
  end
end
