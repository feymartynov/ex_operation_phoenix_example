defmodule App.Post.Create do
  alias App.{Repo, Post}
  alias App.Post.SharedHelpers

  use ExOperation.Operation,
    params: %{
      title!: :string,
      text!: :string,
      tags: :string
    }

  def call(operation) do
    operation
    |> step(:create_post, fn _ ->
      %Post{}
      |> SharedHelpers.changeset(operation.params)
      |> Ecto.Changeset.put_assoc(:author, operation.context.user)
      |> Repo.insert()
    end)
  end

  defdelegate changeset(post, attrs), to: SharedHelpers
end
