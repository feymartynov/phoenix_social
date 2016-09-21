defmodule PhoenixSocial.SessionController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.Session

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
        user = user |> Repo.preload(:friendships)

        conn
        |> put_status(:created)
        |> json(%{jwt: jwt, user: user})
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def delete(conn, _params) do
    {:ok, claims} = Guardian.Plug.claims(conn)

    conn
    |> Guardian.Plug.current_token
    |> Guardian.revoke!(claims)

    json conn, %{ok: true}
  end
end