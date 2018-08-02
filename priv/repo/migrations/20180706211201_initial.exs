defmodule App.Repo.Migrations.Initial do
  use Ecto.Migration

  def up do
    create table(:users) do
      add(:name, :string, null: false)
      add(:encrypted_password, :string, null: false)
      timestamps()
    end

    execute("CREATE UNIQUE INDEX users_name_index ON users (LOWER(name))")

    create table(:posts) do
      add(:author_id, references(:users, on_delete: :delete_all), null: false)
      add(:title, :string, null: false)
      add(:text, :string, null: false)
      add(:comments_count, :integer, null: false, default: 0)
      timestamps()
    end

    create(index(:posts, :author_id))
    create(index(:posts, :inserted_at))

    create table(:comments) do
      add(:post_id, references(:posts, on_delete: :delete_all), null: false)
      add(:author_id, references(:users, on_delete: :delete_all), null: false)
      add(:text, :string, null: false)
      timestamps()
    end

    create(index(:comments, :post_id))
    create(index(:comments, :author_id))
    create(index(:comments, :inserted_at))

    create table(:tags) do
      add(:name, :string, null: false)
    end

    execute("CREATE UNIQUE INDEX tags_name_index ON users (LOWER(name))")

    create table(:post_tags) do
      add(:post_id, references(:posts, on_delete: :delete_all), null: false)
      add(:tag_id, references(:tags, on_delete: :delete_all), null: false)
    end

    create(index(:post_tags, :post_id))
    create(index(:post_tags, :tag_id))
  end

  def down do
    drop(table(:post_tags))
    drop(table(:tags))
    drop(table(:comments))
    drop(table(:posts))
    drop(table(:users))
  end
end
