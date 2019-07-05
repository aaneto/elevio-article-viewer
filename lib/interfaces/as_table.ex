defprotocol AsTable do
  @doc "Return representation of object as ASCII Table."
  def as_table(data)
end

defimpl AsTable, for: Elevio.Article do
  def as_table(article) do
    Enum.join(
      [
        "Id: #{article.id}",
        "Title: #{article.title}",
        "Status: #{article.status}",
        "Source: #{article.source}",
        "Author.name: #{article.author.name}",
        "Author.email: #{article.author.email}",
        "Created @: #{article.created_at}"
      ],
      "\n"
    )
  end
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

defimpl AsTable, for: Elevio.PaginatedArticles do
  def as_table(paginated_articles) do
    tables =
      Enum.map(paginated_articles.articles, fn article ->
        Enum.join(
          [
            "\nTitle: #{article.title}",
            "Id: #{article.id}",
            "Status: #{article.status}"
          ],
          "\n"
        )
      end)

    Enum.join(tables, "\n-----------\n")
  end
end
