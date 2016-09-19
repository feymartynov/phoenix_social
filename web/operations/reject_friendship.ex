defmodule PhoenixSocial.Operations.RejectFriendship do
  alias PhoenixSocial.{Repo, Friendship}

  def call(friendship) do
    if friendship.state != "rejected" do
      friendship
      |> Friendship.changeset(%{state: "rejected"})
      |> Repo.update
    else
      {:error, "Already rejected"}
    end
  end
end
