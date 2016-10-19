defmodule PhoenixSocial.Repo.Migrations.AddAuthorIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :author_id, references(:users)
    end

    execute """
      UPDATE posts SET author_id = user_id
    """

    alter table(:posts) do
      modify :author_id, :integer, null: false
    end

    create index(:posts, [:author_id])
  end
end
