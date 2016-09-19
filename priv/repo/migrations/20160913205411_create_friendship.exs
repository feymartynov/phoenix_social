defmodule PhoenixSocial.Repo.Migrations.CreateFriendship do
  use Ecto.Migration

  def change do
    create table(:friendships, primary_key: false) do
      add(
        :user1_id,
        references(:users, on_delete: :delete_all),
        null: false,
        primary_key: true)

      add(
        :user2_id,
        references(:users, on_delete: :delete_all),
        null: false,
        primary_key: true)

      add :state, :string, null: false, default: "pending"
      timestamps
    end

    create index(:friendships, [:user1_id])
    create index(:friendships, [:user2_id])
  end
end
