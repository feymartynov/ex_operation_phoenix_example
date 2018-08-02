defmodule AppWeb.CommentController do
  use AppWeb, :controller
  alias App.Comment

  def create(conn, params) do
    with {:ok, _} <- Comment.Create |> run(conn, params, form_name: "comment") do
      conn |> redirect(to: post_path(conn, :show, params["post_id"]))
    end
  end

  def update(conn, params) do
    with {:ok, _} <- Comment.Update |> run(conn, params, form_name: "comment") do
      conn |> redirect(to: post_path(conn, :show, params["post_id"]))
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- Comment.Delete |> run(conn, params) do
      conn |> redirect(to: post_path(conn, :show, params["post_id"]))
    end
  end
end
