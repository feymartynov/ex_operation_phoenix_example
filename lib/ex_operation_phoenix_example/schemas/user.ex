defmodule App.User do
  use Ecto.Schema

  schema "users" do
    field(:name, :string)
    field(:encrypted_password, :string)
    timestamps()
  end
end
