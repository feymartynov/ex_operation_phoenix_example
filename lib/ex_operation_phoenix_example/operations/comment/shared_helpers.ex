defmodule App.Comment.SharedHelpers do
  import Ecto.Changeset
  import Ecto.Query
  alias App.{Repo, Post}

  def authorize(user, comment) do
    if user.id == comment.author_id do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text])
  end

  def increment_counter(%Post{id: post_id}, count) do
    query = from(p in Post, where: p.id == ^post_id)
    {result, _} = query |> Repo.update_all(inc: [comments_count: count])
    {:ok, result}
  end
end
