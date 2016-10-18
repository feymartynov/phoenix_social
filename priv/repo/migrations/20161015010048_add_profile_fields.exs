defmodule PhoenixSocial.Repo.Migrations.AddProfileFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :birthday, :date
      add :gender, :string
      add :marital_status, :string
      add :city, :string
      add :languages, :string
      add :occupation, :string
      add :interests, :string
      add :favourite_music, :string
      add :favourite_movies, :string
      add :favourite_books, :string
      add :favourite_games, :string
      add :favourite_cites, :string
      add :about, :string
    end
  end
end
