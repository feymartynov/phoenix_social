defmodule PhoenixSocial.FriendController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User, FriendshipView}
  alias PhoenixSocial.Operations.{AddToFriends, ConfirmFriendship, RejectFriendship}

  plug Guardian.Plug.EnsureAuthenticated

  def create(conn, %{"user_id" => user_id}) do
    if friendship = find_friendship(conn, user_id) do
      conn |> call_operation(ConfirmFriendship, [friendship])
    else
      add_friendship(conn, Repo.get(User, user_id))
    end
  end

  def delete(conn, %{"id" => user_id}) do
    if friendship = find_friendship(conn, user_id) do
      conn |> call_operation(RejectFriendship, [friendship])
    else
      conn |> put_status(:not_found) |> json(%{"error" => "Friend not found"})
    end
  end

  defp add_friendship(conn, nil) do
    conn |> put_status(:not_found) |> json(%{"error" => "User not found"})
  end
  defp add_friendship(conn, user) do
    args = [conn.assigns[:current_user], user]
    conn |> call_operation(AddToFriends, args, ok_status: :created)
  end

  defp find_friendship(conn, user_id) do
    conn.assigns[:current_user]
    |> Ecto.assoc(:friendships)
    |> where(user2_id: ^user_id)
    |> preload(:user2)
    |> Repo.one
  end

  defp call_operation(conn, operation, args, opts \\ [ok_status: :ok]) do
    case apply(operation, :call, args) do
      {:ok, {friendship, back_friendship}} ->
        view = FriendshipView.render(friendship, back_friendship)
        conn |> put_status(opts[:ok_status]) |> json(%{"friendship" => view})
      {:error, error} ->
        conn |> respond_with_error(error)
    end
  end
end
