defmodule PhoenixSocial.GuardianSerializer do
  @behaviour Guardian.Serializer
  alias PhoenixSocial.{Repo, User}

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id) do
    user =
      User
      |> Repo.get!(String.to_integer(id))
      |> Repo.preload([:profile, :friendships])

    {:ok, user}
  end
  def from_token(_), do: {:error, "Unknown resource type"}
end
