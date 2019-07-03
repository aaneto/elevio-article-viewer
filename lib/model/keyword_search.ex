defmodule Elevio.KeywordResult do
  @derive [Poison.Encoder]
  defstruct [
    :category_id,
    :id,
    :title
  ]
end

defmodule Elevio.KeywordSearch do
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
