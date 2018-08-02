defmodule AppWeb.PostController do
  use AppWeb, :controller
  import Ecto.Query
  alias App.{Post, Comment}

  def index(conn, params) do
    query = Post.IndexQuery.build(params)
    conn |> render(posts: Repo.all(query))
  end

  @preloads [:author, :tags, comments: {from(c in Comment, order_by: c.inserted_at), [:author]}]

  def show(conn, %{"id" => id}) do
    case Post |> Repo.get(id) do
      %Post{} = post ->
        render(
          conn,
          post: post |> Repo.preload(@preloads),
          edit_comment_changeset: Comment.Update |> changeset(%{}, form_name: "comment"),
          new_comment_changeset: Comment.Create |> changeset(%{}, form_name: "comment")
        )

      nil ->
        {:error, :not_found}
    end
  end

  def new(conn, params) do
    changeset = Post.Create |> changeset(params, form_name: "post")
    conn |> render(changeset: changeset)
  end

  def create(conn, params) do
    with {:ok, %{create_post: post}} <- Post.Create |> run(conn, params, form_name: "post") do
      conn |> redirect(to: post_path(conn, :show, post.id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:new, changeset: changeset)

      other ->
        other
    end
  end

  def edit(conn, params) do
    changeset = Post.Update |> changeset(params, form_name: "post")
    conn |> render(changeset: changeset)
  end

  def update(conn, params) do
    with {:ok, %{update_post: post}} <- Post.Update |> run(conn, params, form_name: "post") do
      conn |> redirect(to: post_path(conn, :show, post.id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render(:edit, changeset: changeset)

      other ->
        other
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- Post.Delete |> run(conn, params) do
      conn |> redirect(to: post_path(conn, :index))
    end
  end
end
