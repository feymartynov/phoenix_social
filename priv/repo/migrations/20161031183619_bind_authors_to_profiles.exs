defmodule PhoenixSocial.Repo.Migrations.BindAuthorsToProfiles do
  use Ecto.Migration

  def change do
    # posts
    alter table(:posts) do
      add :new_author_id, references(:profiles)
    end

    execute """
      UPDATE posts
      SET new_author_id = profiles.id
      FROM profiles
      WHERE profiles.user_id = posts.author_id
    """

    alter table(:posts) do
      remove :author_id
    end

    rename table(:posts), :new_author_id, to: :author_id 

    alter table(:posts) do
      modify :author_id, :integer, null: false
    end

    create index(:posts, [:profile_id])
    create index(:posts, [:author_id])

    # comments
    alter table(:comments) do
      add :new_author_id, references(:profiles)
    end

    execute """
      UPDATE comments
      SET new_author_id = profiles.id
      FROM profiles
      WHERE profiles.user_id = comments.author_id
    """

    alter table(:comments) do
      remove :author_id
    end

    rename table(:comments), :new_author_id, to: :author_id 

    alter table(:comments) do
      modify :author_id, :integer, null: false
    end

    create index(:comments, [:author_id])
  end
end
