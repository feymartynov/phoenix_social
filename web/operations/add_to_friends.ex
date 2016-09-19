defmodule PhoenixSocial.Operations.AddToFriends do
  alias PhoenixSocial.Repo

  def call(user, user) do
    {:error, "Impossible to add oneself to friends"}
  end
  def call(current_user, user) do
    Repo.transaction fn ->
      build_friendship(current_user, user) |> Repo.insert!
      build_back_friendship(current_user, user) |> Repo.insert!
    end
  end

  defp build_friendship(current_user, user) do
    Ecto.build_assoc(
      current_user,
      :friendships,
      user2: user,
      state: "confirmed")
  end

  defp build_back_friendship(current_user, user) do
    Ecto.build_assoc(
      user,
      :friendships,
      user2: current_user,
      state: "pending")
  end
end
