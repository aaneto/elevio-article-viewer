defprotocol AsTable do
  @doc "Return representation of object as ASCII Table."
  def as_table(data)
end

defimpl AsTable, for: Elevio.KeywordSearch do
  def as_table(search) do
    tables =
      Enum.map(search.results, fn result ->
        Enum.join(
          [
            "\ntitle: #{result.title}",
            "category_id: #{result.category_id}",
            "id: #{result.id}"
          ],
          "\n"
        )
      end)

    Enum.join(tables, "\n-----------\n")
  end
end
