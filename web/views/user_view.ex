defmodule PhoenixSocial.UserView do
  import Ecto.Query

  alias PhoenixSocial.{Repo, Friendship, FriendshipView, ProfileView}

  def render(user, opts \\ [as: nil]) do
    user = user |> preload_friendships(opts[:as])

    %{id: user.id,
      profile: user.profile |> ProfileView.render,
      friendships: render_friends(user)}
  end

  defp preload_friendships(user, user) do
    Repo.preload(user, [friendships: [user2: :profile]])
  end
  defp preload_friendships(user, _as) do
    query =
      from f in Friendship,
      where: f.state == "confirmed",
      preload: [user2: :profile]

    Repo.preload(user, friendships: query)
  end

  defp render_friends(user) do
    user.friendships |> Enum.map(&FriendshipView.render/1)
  end
end
