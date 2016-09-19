defmodule PhoenixSocial.FriendController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User}
  alias PhoenixSocial.Operations.{AddToFriends, ConfirmFriendship, RejectFriendship}

  plug Guardian.Plug.EnsureAuthenticated

  def index(conn, _params) do
    friends =
      conn.assigns[:current_user]
      |> Ecto.assoc(:friendships)
      |> Repo.all
      |> Repo.preload(:user2)

    conn
    |> put_status(:ok)
    |> json(%{friends: friends})
  end

  def create(conn, %{"user_id" => user_id}) do
    friendship = find_friendship(conn, user_id)

    {status, result} =
      cond do
        is_nil(friendship) ->
          user = Repo.get(User, user_id)
          add_to_friends(conn.assigns[:current_user], user)
        friendship.state != "confirmed" ->
          ConfirmFriendship.call(friendship)
          {:ok, "Friendship with #{User.full_name(friendship.user2)} confirmed"}
        true ->
          {:unprocessable_entity,
           "#{User.full_name(friendship.user2)} has been already added to friends"}
      end

    conn
    |> put_status(status)
    |> json(%{"result" => result})
  end

  defp add_to_friends(_, nil), do: {:not_found, "User not found"}
  defp add_to_friends(current_user, user) do
    case AddToFriends.call(current_user, user) do
      {:ok, _friendship} ->
        {:created, "#{User.full_name(user)} added to friends"}
      {:error, error} ->
        {:unprocessable_entity, error}
    end
  end

  def delete(conn, %{"id" => user_id}) do
    friendship = find_friendship(conn, user_id)

    {status, result} =
      case friendship && RejectFriendship.call(friendship) do
        {:ok, friendship} ->
          {:ok, "#{User.full_name(friendship.user2)} deleted from friends"}
        {:error, error} ->
          {:unprocessable_entity, error}
        nil ->
          {:not_found, "Friend not found"}
      end

    conn
    |> put_status(status)
    |> json(%{"result" => result})
  end

  defp find_friendship(conn, user_id) do
    conn.assigns[:current_user]
    |> Ecto.assoc(:friendships)
    |> where(user2_id: ^user_id)
    |> preload(:user2)
    |> Repo.one
  end
end
