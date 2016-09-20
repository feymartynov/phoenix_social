defmodule PhoenixSocial.Operations.AddToFriends do
  alias PhoenixSocial.Repo

  def call(user, user) do
    {:error, "Impossible to add oneself to friends"}
  end
  def call(current_user, user) do
    Repo.transaction fn ->
      {:ok, friendship} = insert_friendship(current_user, user)
      {:ok, back_friendship} = insert_back_friendship(current_user, user)
      {friendship, back_friendship}
    end
  end

  defp insert_friendship(current_user, user) do
    Repo.insert(
      Ecto.build_assoc(
        current_user,
        :friendships,
        user2: user,
        state: "confirmed"))
  end

  defp insert_back_friendship(current_user, user) do
    Repo.insert(
      Ecto.build_assoc(
        user,
        :friendships,
        user2: current_user,
        state: "pending"))
  end
end
