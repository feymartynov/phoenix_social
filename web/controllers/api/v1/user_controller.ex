defmodule PhoenixSocial.UserController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User}
  alias Guardian.Plug.EnsureAuthenticated

  plug :scrub_params, "user" when action in [:create]
  plug EnsureAuthenticated when action in [:show]

  def show(conn, %{"id" => id}) do
    user =
      find_user(conn, id)
      |> Repo.preload(friendships: :user2)

    if user do
      conn
      |> put_status(:ok)
      |> json(%{user: user})
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    end
  end

  defp find_user(conn, "current"), do: conn.assigns[:current_user]
  defp find_user(_conn, id), do: Repo.get(User, id)

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> json(%{jwt: jwt, user: user})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: User.error_messages(changeset)})
    end
  end
end
