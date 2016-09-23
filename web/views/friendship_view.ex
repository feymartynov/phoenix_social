defmodule PhoenixSocial.FriendshipView do
  alias PhoenixSocial.{Repo, Friendship}

  def render(friendship), do: render(friendship, nil)
  def render(friendship, nil) do
    friendship
    |> Repo.preload(:user2)
    |> Map.fetch!(:user2)
    |> Map.take([:id, :first_name, :last_name])
    |> Map.put(:state, friendship.state)
  end
  def render(friendship, back_friendship) do
    render(friendship, nil)
    |> Map.put(:back_friendship, render(back_friendship, nil))
  end
end
