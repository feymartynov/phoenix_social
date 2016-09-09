defmodule PhoenixSocial.SessionController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.Session

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def delete(conn, _params) do
    {:ok, claims} = Guardian.Plug.claims(conn)

    conn
    |> Guardian.Plug.current_token
    |> Guardian.revoke!(claims)

    conn
    |> render("delete.json")
  end
end