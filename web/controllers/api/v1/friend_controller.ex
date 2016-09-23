defmodule PhoenixSocial.FriendController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User}
  alias PhoenixSocial.Operations.{AddToFriends, ConfirmFriendship, RejectFriendship}

  plug Guardian.Plug.EnsureAuthenticated

  def create(conn, %{"user_id" => user_id}) do
    if friendship = find_friendship(conn, user_id) do
      confirm_friendship(conn, friendship)
    else
      add_friendship(conn, Repo.get(User, user_id))
    end
  end

  defp confirm_friendship(conn, %{state: "confirmed", user2: friend}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{"error" => "#{friend} has been already added to friends"})
  end
  defp confirm_friendship(conn, friendship) do
    case ConfirmFriendship.call(friendship) do
      {:ok, friendships} ->
        conn
        |> put_status(:ok)
        |> json(show_friendships(friendships))

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"error" => error})
    end
  end

  defp add_friendship(conn, nil) do
    conn
    |> put_status(:not_found)
    |> json(%{"error" => "User not found"})
  end
  defp add_friendship(conn, user) do
    case AddToFriends.call(conn.assigns[:current_user], user) do
      {:ok, friendships} ->
        conn
        |> put_status(:created)
        |> json(show_friendships(friendships))

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"error" => error})
    end
  end

  def delete(conn, %{"id" => user_id}) do
    if friendship = find_friendship(conn, user_id) do
      reject_friendship(conn, friendship)
    else
      conn
      |> put_status(:not_found)
      |> json(%{"error" => "Friend not found"})
    end
  end

  defp reject_friendship(conn, friendship) do
    case RejectFriendship.call(friendship) do
      {:ok, friendships} ->
        conn
        |> put_status(:ok)
        |> json(show_friendships(friendships))

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"error" => error})
    end
  end

  defp find_friendship(conn, user_id) do
    conn.assigns[:current_user]
    |> Ecto.assoc(:friendships)
    |> where(user2_id: ^user_id)
    |> preload(:user2)
    |> Repo.one
  end

  defp show_friendships({friendship, back_friendship}) do
    %{"friendship" => friendship |> Repo.preload(:user2),
      "back_friendship" => back_friendship |> Repo.preload(:user2)}
  end
end
