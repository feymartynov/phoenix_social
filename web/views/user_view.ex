defmodule PhoenixSocial.UserView do
  import Ecto.Query

  alias PhoenixSocial.{Repo, Friendship, Avatar, FriendshipView}

  @fields [
    :id, :first_name, :last_name, :birthday, :gender, :marital_status, :city,
    :languages, :occupation, :interests, :favourite_music, :favourite_movies,
    :favourite_books, :favourite_games, :favourite_cites, :about]

  def render(user, opts \\ [as: nil]) do
    user = user |> preload_friendships(opts[:as])

    user
    |> Map.take(@fields)
    |> Map.put(:avatar, Avatar.public_urls({user.avatar, user}))
    |> Map.put(:friendships, render_friends(user))
  end

  defp preload_friendships(user, user) do
    Repo.preload(user, friendships: :user2)
  end
  defp preload_friendships(user, _as) do
    query = from f in Friendship, where: f.state == "confirmed"
    Repo.preload(user, friendships: query)
  end

  defp render_friends(user) do
    user.friendships |> Enum.map(&FriendshipView.render(&1))
  end
end
