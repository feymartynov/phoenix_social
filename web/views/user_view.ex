defmodule PhoenixSocial.UserView do
  import Ecto.Query

  alias PhoenixSocial.{Repo, Friendship, FriendshipView}

  def render(user, opts \\ [as: nil]) do
    user = user |> preload_friendships(opts[:as])

    user
    |> Map.take([:id, :first_name, :last_name])
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