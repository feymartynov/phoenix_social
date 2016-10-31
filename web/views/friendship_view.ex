defmodule PhoenixSocial.FriendshipView do
  alias PhoenixSocial.{Repo, Profile, Avatar}

  def render(friendship), do: render(friendship, nil)
  def render(friendship, nil) do
    friend = friendship |> Repo.preload(user2: :profile) |> Map.fetch!(:user2)

    friend.profile
    |> Map.take([:id, :first_name, :last_name])
    |> Map.put(:user_id, friend.id)
    |> Map.put(:slug, friend.profile |> Profile.slug)
    |> Map.put(:full_name, friend.profile |> Profile.full_name)
    |> Map.put(:avatar, Avatar.public_urls({friend.profile.avatar, friend.profile}))
    |> Map.put(:state, friendship.state)
  end
  def render(friendship, back_friendship) do
    render(friendship, nil)
    |> Map.put(:back_friendship, render(back_friendship, nil))
  end
end
