defmodule App.Post.SharedHelpers do
  import Ecto.Changeset

  def authorize(user, post) do
    if user.id == post.author_id do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end

  def changeset(post, attrs) do
    post
    |> cast(prepare_attrs(attrs), [:title, :text])
    |> cast_assoc(:tags, with: &tag_changeset/2)
  end

  defp prepare_attrs(attrs) do
    attrs
    |> Map.put(:tags, attrs[:tags] |> split_tags() |> Enum.map(&%{name: &1}))
  end

  defp split_tags(nil), do: []
  defp split_tags(tags), do: tags |> String.split(",") |> Enum.map(&String.trim/1)

  defp tag_changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required(:name)
  end
end
