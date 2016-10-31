defmodule PhoenixSocial.SharedPlugs do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, User, Profile}

  def find_user(conn, _) do
    id = conn.params["user_id"] || conn.params["id"]
    current_user = conn.assigns.current_user

    cond do
      id in ["current", current_user.id |> to_string] ->
        conn |> assign(:user, current_user)
      user = Repo.get(User, id) ->
        conn |> assign(:user, user)
      true ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
        |> halt
    end
  end

  def find_profile(conn, opts \\ []) do
    authorize? = opts |> Keyword.get(:authorize, true)
    current_user = conn.assigns.current_user
    id = conn.params["profile_id"] || conn.params["id"]
    profile = Repo.get(Profile, id)

    cond do
      is_nil(profile) ->
        error = "Profile not found"
        conn |> put_status(:not_found) |> json(%{error: error}) |> halt
       authorize? && profile.user_id != current_user.id ->
        error = "Forbidden"
        conn |> put_status(:forbidden) |> json(%{error: error}) |> halt
      true ->
        conn |> assign(:profile, profile)
    end
  end
end
