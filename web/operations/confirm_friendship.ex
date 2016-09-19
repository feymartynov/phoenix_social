defmodule PhoenixSocial.Operations.ConfirmFriendship do
  alias PhoenixSocial.{Repo, Friendship}

  def call(%{state: "confirmed"}), do: {:error, "Already confirmed"}
  def call(friendship) do
    friendship
    |> Friendship.changeset(%{state: "confirmed"})
    |> Repo.update
  end
end
