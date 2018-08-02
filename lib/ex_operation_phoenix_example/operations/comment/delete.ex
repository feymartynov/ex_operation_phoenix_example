defmodule App.Comment.Delete do
  alias App.{Repo, Comment}
  alias App.Comment.SharedHelpers

  use ExOperation.Operation, params: %{id!: :integer}

  def call(operation) do
    operation
    |> find(:comment, schema: Comment, preloads: [:post])
    |> step(:authorize_comment, &SharedHelpers.authorize(operation.context.user, &1.comment))
    |> step(:delete_comment, &(&1.comment |> Repo.delete()))
    |> step(:decrement_counter, &SharedHelpers.increment_counter(&1.comment.post, -1))
  end
end
