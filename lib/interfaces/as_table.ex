defprotocol AsTable do
  @doc "Return representation of object as ASCII Table."
  def as_table(data)
end
