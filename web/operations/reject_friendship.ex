defmodule PhoenixSocial.Operations.RejectFriendship do
  import PhoenixSocial.Friendship, only: [toggle_state: 2, back_friendship: 1]
  alias PhoenixSocial.Repo

  def call(%{state: "rejected"}), do: {:error, "Already rejected"}
  def call(%{state: "cancelled"}), do: {:error, "Already cancelled"}
  def call(friendship) do
    Repo.transaction fn ->
      {:ok, friendship} = friendship |> toggle_state("rejected")
      {:ok, back_friendship} = friendship |> cancel_back
      {friendship, back_friendship}
    end
  end

  defp cancel_back(friendship) do
    if back_friendship = back_friendship(friendship) do
      back_friendship |> cancel
    else
      {:error, "Back friendship not found"}
    end
  end

  defp cancel(%{state: "pending"} = f), do: f |> toggle_state("cancelled")
  defp cancel(friendship), do: {:ok, friendship}
end
