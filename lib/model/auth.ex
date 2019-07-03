defmodule Elevio.Auth do
  @moduledoc """
  The Auth struct is a placeholder
  for authentication data: the api_key
  and the token.
  """
  @enforce_keys [
    :token,
    :api_key
  ]
  defstruct [
    :token,
    :api_key
  ]
end
