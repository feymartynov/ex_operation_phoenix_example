defmodule AppWeb.UserController do
  use AppWeb, :controller
  alias App.User

  plug(:scrub_params, "user" when action in [:create, :update])

  def new(conn, params) do
    changeset = User.Create |> changeset(params, form_name: :user)
    conn |> render(:new, changeset: changeset)
  end

  def create(conn, params) do
    with {:ok, %{create_user: user}} <- User.Create |> run(conn, params, form_name: :user) do
      conn
      |> put_session(:current_user_id, user.id)
      |> put_flash(:info, gettext("You have successfully signed up!"))
      |> redirect(to: "/")
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, gettext("Wrong form values given."))
        |> render(:new, changeset: changeset)
    end
  end
end
