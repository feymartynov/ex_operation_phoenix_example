defmodule AppWeb.Authenticate do
  import Plug.Conn
  alias App.{Repo, User}

  def init(opts), do: opts

  def call(conn, _opts) do
    with id when is_integer(id) <- conn |> get_session(:current_user_id),
         %User{} = user <- User |> Repo.get(id) do
      conn |> assign(:current_user, user)
    else
      _ ->
        conn
        |> Phoenix.Controller.redirect(to: AppWeb.Router.Helpers.session_path(conn, :new))
        |> halt()
    end
  end
end
