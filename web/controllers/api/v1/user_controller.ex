defmodule PhoenixSocial.UserController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User, UserView, SessionController}
  alias Guardian.Plug.EnsureAuthenticated

  plug :scrub_params, "user" when action in [:create]
  plug EnsureAuthenticated when action in [:show]

  def show(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("show.json", user: current_user(conn))
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render("create.json", jwt: jwt, user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
