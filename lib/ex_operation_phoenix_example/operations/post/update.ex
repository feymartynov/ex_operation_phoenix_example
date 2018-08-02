defmodule App.Post.Update do
  alias App.{Repo, Post}
  alias App.Post.SharedHelpers

  use ExOperation.Operation,
    params: %{
      id!: :integer,
      title!: :string,
      text!: :string,
      tags: :string
    }

  def call(operation) do
    operation
    |> find(:post, schema: Post)
    |> step(:authorize_post, &SharedHelpers.authorize(operation.context.user, &1.post))
    |> step(:update_post, fn %{post: post} ->
      post |> SharedHelpers.changeset(operation.params) |> Repo.update()
    end)
  end

  defdelegate changeset(post, attrs), to: SharedHelpers
end
