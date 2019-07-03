defmodule Elevio.Auth do
  @enforce_keys [
    :token,
    :api_key
  ]
  defstruct [
    :token,
    :api_key
  ]
end
