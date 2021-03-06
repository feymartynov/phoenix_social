defmodule PhoenixSocial.Operations.ConfirmFriendship do
  alias PhoenixSocial.{Repo, Friendship}

  def call(%{state: "confirmed"}), do: {:error, "Already confirmed"}
  def call(friendship) do
    Repo.transaction fn ->
      {:ok, friendship} = confirm(friendship)
      {:ok, back_friendship} = put_back_friendship_pending(friendship)
      {friendship, back_friendship}
    end
  end

  defp confirm(friendship) do
    Friendship.toggle_state(friendship, "confirmed") |> Repo.update
  end

  defp put_back_friendship_pending(friendship) do
    back = Friendship.back_friendship(friendship) |> Repo.one

    if back && back.state == "cancelled" do
      Friendship.toggle_state(back, "pending") |> Repo.update
    else
      {:ok, back}
    end
  end
end
