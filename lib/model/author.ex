defmodule Elevio.Author do
  @moduledoc """
  The Author object contains metadata
  about a particular Author.
  """
  @derive [Poison.Encoder]
  defstruct [
    :id,
    :name,
    :email,
    :gravatar
  ]

  def find_missing_fields(author) do
    required_fields = [
      :id,
      :name,
      :email
    ]

    case Enum.find(required_fields, fn field -> is_nil(Map.get(author, field)) end) do
      nil -> {:ok, author}
      field -> {:error, {:missingfield, :author, field}}
    end
  end
end
