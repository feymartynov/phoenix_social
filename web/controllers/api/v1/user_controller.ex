defmodule PhoenixSocial.UserController do
  use PhoenixSocial.Web, :controller
  import PhoenixSocial.SharedPlugs, only: [find_user: 2]

  alias PhoenixSocial.{Repo, User, UserView}

  plug Guardian.Plug.EnsureAuthenticated when action in [:show]
  plug :scrub_params, "user" when action in [:create]
  plug :find_user when action in [:show]

  def show(conn, _params) do
    user = conn.assigns.user |> Repo.preload(:profile)
    user_view = UserView.render(user, as: conn.assigns.current_user)
    conn |> put_status(:ok) |> json(%{user: user_view})
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
        view = UserView.render(user, as: conn.assigns.current_user)
        conn |> put_status(:created) |> json(%{jwt: jwt, user: view})
      {:error, changeset} ->
        error = User.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end
end
