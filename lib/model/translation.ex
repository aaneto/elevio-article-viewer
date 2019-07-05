defmodule Elevio.Translation do
  @moduledoc """
  The Translation is a textual representation of the
  Article, containing the body text in a particular language.
  """
  defstruct [
    :id,
    :body,
    :title,
    :summary,
    :created_at,
    :updated_at,
    :language_id,
    :machine_summary,
    :featured_image_url
  ]
end
