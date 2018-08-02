defmodule App.Post.IndexQuery do
  import Ecto.Query

  def build(params) do
    query = from(p in App.Post, order_by: [desc: p.inserted_at], preload: [:author, :tags])
    query |> filter_by_tag(params["tag"])
  end

  defp filter_by_tag(query, nil), do: query

  defp filter_by_tag(query, tag) do
    query
    |> join(:inner, [p], t in assoc(p, :tags))
    |> where([p, t], t.name == ^tag)
    |> group_by([p], p.id)
  end
end
