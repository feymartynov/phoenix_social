defmodule PhoenixSocial.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :user_id, references(:users)
      add :first_name, :string
      add :last_name, :string
      add :avatar, :string
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

    execute """
      INSERT INTO profiles (
        user_id,
        first_name,
        last_name,
        avatar,
        birthday,
        gender,
        marital_status,
        city,
        languages,
        occupation,
        interests,
        favourite_music,
        favourite_movies,
        favourite_books,
        favourite_games,
        favourite_cites,
        about)
      SELECT
        id AS user_id,
        first_name,
        last_name,
        avatar,
        birthday,
        gender,
        marital_status,
        city,
        languages,
        occupation,
        interests,
        favourite_music,
        favourite_movies,
        favourite_books,
        favourite_games,
        favourite_cites,
        about
      FROM users
    """

    alter table(:profiles) do
      modify :user_id, :integer, null: false
    end
    
    alter table(:users) do
      remove :first_name
      remove :last_name
      remove :avatar
      remove :birthday
      remove :gender
      remove :marital_status
      remove :city
      remove :languages
      remove :occupation
      remove :interests
      remove :favourite_music
      remove :favourite_movies
      remove :favourite_books
      remove :favourite_games
      remove :favourite_cites
      remove :about
    end

    create index(:profiles, [:user_id])
  end
end
