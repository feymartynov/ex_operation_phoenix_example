defmodule App.Comment.Create do
  alias App.{Repo, Comment, Post}
  alias App.Comment.SharedHelpers

  use ExOperation.Operation,
    params: %{
      post_id!: :integer,
      text!: :string
    }

  def call(operation) do
    operation
    |> find(:post, schema: Post, id_path: :post_id)
    |> step(:create_comment, fn %{post: post} ->
      %Comment{}
      |> SharedHelpers.changeset(operation.params)
      |> Ecto.Changeset.put_assoc(:post, post)
      |> Ecto.Changeset.put_assoc(:author, operation.context.user)
      |> Repo.insert()
    end)
    |> step(:increment_counter, &SharedHelpers.increment_counter(&1.post, 1))
  end

  defdelegate changeset(post, attrs), to: SharedHelpers
end
