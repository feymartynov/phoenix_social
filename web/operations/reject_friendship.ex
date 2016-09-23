defmodule PhoenixSocial.Operations.RejectFriendship do
  import PhoenixSocial.Friendship, only: [toggle_state: 2, back_friendship: 1]
  alias PhoenixSocial.Repo

  def call(%{state: "rejected"}), do: {:error, "Already rejected"}
  def call(%{state: "cancelled"}), do: {:error, "Already cancelled"}
  def call(friendship) do
    Repo.transaction fn ->
      {:ok, friendship} = friendship |> reject
      {:ok, back_friendship} = friendship |> cancel_back
      {friendship, back_friendship}
    end
  end

  defp reject(friendship) do
    friendship |> toggle_state("rejected") |> Repo.update
  end

  defp cancel_back(friendship) do
    if back_friendship = back_friendship(friendship) |> Repo.one do
      back_friendship |> cancel
    else
      {:error, "Back friendship not found"}
    end
  end

  defp cancel(%{state: "pending"} = friendship) do
    friendship |> toggle_state("cancelled") |> Repo.update
  end
  defp cancel(friendship), do: {:ok, friendship}
end
