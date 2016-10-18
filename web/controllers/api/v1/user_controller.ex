defmodule PhoenixSocial.UserController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User, UserView}
  alias Guardian.Plug.EnsureAuthenticated

  plug :scrub_params, "user" when action in [:create, :update]
  plug :find_user when action in [:show, :update]
  plug :restrict_current_user when action in [:update]
  plug EnsureAuthenticated when action in [:show, :update]

  def show(conn, _params) do
    user = conn.assigns[:user]
    user_view = UserView.render(user, as: conn.assigns[:current_user])
    conn |> put_status(:ok) |> json(%{user: user_view})
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
        view = UserView.render(user, as: conn.assigns[:current_user])
        conn |> put_status(:created) |> json(%{jwt: jwt, user: view})
      {:error, changeset} ->
        conn |> respond_with_error(changeset)
    end
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User.profile_changeset(conn.assigns[:user], user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        user_view = UserView.render(user, as: conn.assigns[:current_user])
        conn |> put_status(:ok) |> json(%{user: user_view})
      {:error, changeset} ->
        conn |> respond_with_error(changeset)
    end
  end

  defp find_user(conn, _) do
    cond do
      conn.params["id"] == "current" ->
        conn |> assign(:user, conn.assigns[:current_user])
      user = Repo.get(User, conn.params["id"]) ->
        conn |> assign(:user, user)
      true ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
        |> halt
    end
  end

  defp restrict_current_user(conn, _) do
    if conn.assigns[:user] == conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
      |> halt
    end
  end

  defp respond_with_error(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: User.error_messages(changeset)})
  end
end
