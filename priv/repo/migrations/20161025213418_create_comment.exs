defmodule PhoenixSocial.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nothing), null: false
      add :text, :string, null: false
      timestamps
    end

    create index(:comments, [:post_id])
    create index(:comments, [:author_id])
  end
end
