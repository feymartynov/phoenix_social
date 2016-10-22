defmodule PhoenixSocial.FriendshipView do
  alias PhoenixSocial.{Repo, Avatar}

  def render(friendship), do: render(friendship, nil)
  def render(friendship, nil) do
    friend = friendship |> Repo.preload(:user2) |> Map.fetch!(:user2)

    friend
    |> Map.take([:id, :first_name, :last_name])
    |> Map.put(:avatar, Avatar.public_urls({friend.avatar, friend}))
    |> Map.put(:state, friendship.state)
  end
  def render(friendship, back_friendship) do
    render(friendship, nil)
    |> Map.put(:back_friendship, render(back_friendship, nil))
  end
end
