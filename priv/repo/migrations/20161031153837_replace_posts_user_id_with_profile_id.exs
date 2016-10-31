defmodule PhoenixSocial.Repo.Migrations.ReplacePostsUserIdWithProfileId do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :profile_id, references(:profiles)
    end

    execute """
      UPDATE posts
      SET profile_id = profiles.id
      FROM profiles
      WHERE profiles.user_id = posts.user_id
    """

    alter table(:posts) do
      modify :profile_id, :integer, null: false
      remove :user_id
    end
  end
end
