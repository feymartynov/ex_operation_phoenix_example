defmodule App.Comment.Update do
  alias App.{Repo, Comment}
  alias App.Comment.SharedHelpers

  use ExOperation.Operation,
    params: %{
      id!: :integer,
      text!: :string
    }

  def call(operation) do
    operation
    |> find(:comment, schema: Comment)
    |> step(:authorize_comment, &SharedHelpers.authorize(operation.context.user, &1.comment))
    |> step(:update_comment, fn %{comment: comment} ->
      comment |> SharedHelpers.changeset(operation.params) |> Repo.update()
    end)
  end

  defdelegate changeset(post, attrs), to: SharedHelpers
end
