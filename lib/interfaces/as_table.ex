defprotocol AsTable do
  @doc "Return representation of object as ASCII Table."
  def as_table(data)
end

defimpl AsTable, for: Elevio.Article do
  def as_table(article) do
    """
    ID: #{article.id}
    Title: #{article.title}
    Status: #{article.status}
    Source: #{article.source}
    Author Name: #{article.author.name}
    Author Email: #{article.author.email}
    Created @: #{article.created_at}
    """
  end
end

defimpl AsTable, for: Elevio.KeywordSearch do
  def as_table(search) do
    tables =
      Enum.map(search.results, fn result ->
        """
        Title: #{result.title}
        Category ID: #{result.category_id}
        ID: #{result.id}
        """
      end)

    Enum.join(tables, "\n-----------\n")
  end
end

defimpl AsTable, for: Elevio.PaginatedArticles do
  def as_table(paginated_articles) do
    tables =
      Enum.map(paginated_articles.articles, fn article ->
        """
        Title: #{article.title}
        Id: #{article.id}
        Status: #{article.status}
        """
      end)

    Enum.join(tables, "\n-----------\n")
  end
end
