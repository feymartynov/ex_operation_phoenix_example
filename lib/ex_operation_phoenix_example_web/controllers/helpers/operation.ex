defmodule AppWeb.Operation do
  # with {:ok, result} <- Comment.Create |> run(conn, params, form_name: "comment") do
  #   comment = result.create_comment
  #   conn |> redirect(to: post_path(conn, :show, comment.post_id))
  # end
  def run(module, conn, params, opts \\ []) do
    context = %{user: conn.assigns[:current_user]}
    params = params |> merge_params(opts)
    module |> ExOperation.run(context, params)
  end

  # changeset = Comment.Create |> changeset(params, form_name: "comment")
  # conn |> render(:new, changeset: changeset)
  def changeset(module, params, opts \\ []) do
    params = params |> merge_params(opts)
    [module, OperationParams] |> Module.concat() |> apply(:from, [params])
  end

  # %{"post_id" => 123, "comment" => %{"text" => "hello"}}
  # =>
  # %{"post_id" => 123, "text" => "hello"}
  defp merge_params(params, form_name: form_name) do
    form_name = form_name |> to_string()
    form_values = params |> Map.get(form_name, %{})
    params |> Map.delete(form_name) |> Map.merge(form_values)
  end

  defp merge_params(params, _), do: params
end
