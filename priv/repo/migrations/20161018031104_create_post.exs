defmodule PhoenixSocial.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :text, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps
    end

    create index(:posts, [:user_id])
    create index(:posts, [:inserted_at])
  end
end
