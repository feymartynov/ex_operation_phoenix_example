defmodule App.User.Create do
  import Ecto.Changeset
  alias App.{Repo, User}

  use ExOperation.Operation,
    params: %{
      name!: :string,
      password!: :string
    }

  def valdiate_params(changeset) do
    changeset
    |> validate_length(:password, min: 6)
  end

  def call(operation) do
    operation
    |> step(:create_user, fn _ -> %User{} |> changeset(operation.params) |> Repo.insert() end)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :users_name_index)
    |> put_encrypted_password(attrs[:password])
  end

  defp put_encrypted_password(changeset, nil), do: changeset

  defp put_encrypted_password(changeset, password) do
    changeset |> put_change(:encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
  end
end
