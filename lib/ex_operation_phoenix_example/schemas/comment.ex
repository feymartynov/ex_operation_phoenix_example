defmodule App.Comment do
  use Ecto.Schema

  schema "comments" do
    field(:text, :string)
    timestamps()

    belongs_to(:post, App.Post)
    belongs_to(:author, App.User)
  end
end
