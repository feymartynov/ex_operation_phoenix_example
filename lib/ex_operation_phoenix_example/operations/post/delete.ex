defmodule App.Post.Delete do
  alias App.{Repo, Post}

  use ExOperation.Operation, params: %{id!: :integer}

  def call(operation) do
    operation
    |> find(:post, schema: Post)
    |> step(:authorize_post, &Post.SharedHelpers.authorize(operation.context.user, &1.post))
    |> step(:delete_post, &(&1.post |> Repo.delete()))
  end
end
