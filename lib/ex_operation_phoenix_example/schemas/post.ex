defmodule App.Post do
  use Ecto.Schema

  schema "posts" do
    field(:title, :string)
    field(:text, :string)
    field(:comments_count, :integer)
    timestamps()

    belongs_to(:author, App.User)
    has_many(:comments, App.Comment)
    many_to_many(:tags, App.Tag, join_through: "post_tags")
  end
end
