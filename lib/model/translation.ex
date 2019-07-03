defmodule Elevio.Translation do
  @moduledoc """
  The Translation is a textual representation of the
  Article, containing the body text in a particular language.
  """
  @derive [Poison.Encoder]
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

  def find_missing_fields(%Elevio.Translation{} = translation) do
    required_fields = [
      :id,
      :created_at,
      :updated_at
    ]

    case Enum.find(required_fields, fn field -> is_nil(Map.get(translation, field)) end) do
      nil -> {:ok, translation}
      field -> {:error, {:missingfield, :translation, field}}
    end
  end

  def find_missing_fields(translations) when is_list(translations) do
    faulty_translation =
      Enum.find(translations, fn translation ->
        case Elevio.Translation.find_missing_fields(translation) do
          {:ok, _} -> false
          {:error, {:missingfield, :translation, _}} -> true
        end
      end)

    case faulty_translation do
      nil -> {:ok, translations}
      translation -> find_missing_fields(translation)
    end
  end
end
