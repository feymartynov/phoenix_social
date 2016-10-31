defmodule PhoenixSocial.ProfileView do
  alias PhoenixSocial.{Avatar, Profile}

  @fields [
    :id, :user_id, :first_name, :last_name, :birthday, :gender, :marital_status,
    :city, :languages, :occupation, :interests, :about, :favourite_music,
    :favourite_movies, :favourite_books, :favourite_games, :favourite_cites]

  def render(profile) do
    profile
    |> Map.take(@fields)
    |> Map.put(:slug, profile |> Profile.slug)
    |> Map.put(:full_name, profile |> Profile.full_name)
    |> Map.put(:avatar, Avatar.public_urls({profile.avatar, profile}))
  end
end
