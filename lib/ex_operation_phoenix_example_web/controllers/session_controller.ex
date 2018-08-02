defmodule AppWeb.SessionController do
  use AppWeb, :controller
  alias App.{Repo, User}

  def new(conn, _params) do
    conn |> render()
  end

  plug(:scrub_params, "session" when action == :create)

  def create(conn, %{"session" => params}) do
    with true <- is_bitstring(params["name"]),
         true <- is_bitstring(params["password"]),
         %User{} = user <- User |> Repo.get_by(name: params["name"]),
         true <- Comeonin.Bcrypt.checkpw(params["password"], user.encrypted_password) do
      conn |> put_session(:current_user_id, user.id) |> redirect(to: "/")
    else
      _ ->
        conn
        |> put_flash(:error, gettext("Wrong name or password."))
        |> redirect(to: "/sign-in")
    end
  end

  def delete(conn, _params) do
    conn |> put_flash(:info, gettext("Goodbye!")) |> redirect(to: "/sign-in")
  end
end
