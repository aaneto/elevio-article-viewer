defmodule Elevio.Author do
  @moduledoc """
  The Author object contains metadata
  about a particular Author.
  """
  defstruct [
    :id,
    :name,
    :email,
    :gravatar
  ]
end
