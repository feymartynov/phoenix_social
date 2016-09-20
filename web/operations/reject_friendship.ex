defmodule PhoenixSocial.Operations.RejectFriendship do
  alias PhoenixSocial.{Repo, Friendship}

  def call(%{state: "rejected"}), do: {:error, "Already rejected"}
  def call(%{state: "cancelled"}), do: {:error, "Already cancelled"}
  def call(friendship) do
    Repo.transaction fn ->
      {:ok, friendship} = Friendship.toggle_state(friendship, "rejected")
      {:ok, back_friendship} = cancel_back_friendship(friendship)
      {friendship, back_friendship}
    end
  end

  defp cancel_back_friendship(friendship) do
    back = Friendship.back_friendship(friendship)

    if back && back.state == "pending" do
      Friendship.toggle_state(back, "cancelled")
    else
      {:ok, back}
    end
  end
end
