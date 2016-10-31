defmodule PhoenixSocial.ProfileController do
  use PhoenixSocial.Web, :controller
  import PhoenixSocial.SharedPlugs, only: [find_profile: 2]

  alias PhoenixSocial.{Repo, Profile, ProfileView, FriendshipView}

  plug Guardian.Plug.EnsureAuthenticated
  plug :scrub_params, "profile" when action in [:update]
  plug :find_profile, [authorize: false] when action in [:show]
  plug :find_profile when action in [:update]

  def show(conn, _params) do
    conn |> respond_with_profile(conn.assigns.profile)
  end

  def update(conn, %{"profile" => profile_params}) do
    changeset = Profile.changeset(conn.assigns.profile, profile_params)

    case Repo.update(changeset) do
      {:ok, profile} ->
        conn |> respond_with_profile(profile)
      {:error, changeset} ->
        error = Profile.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  defp respond_with_profile(conn, profile) do
    profile = profile |> Repo.preload(user: :friendships)

    friendships =
      profile.user.friendships
      |> Enum.map(&FriendshipView.render/1)

    profile_view =
      ProfileView.render(profile)
      |> Map.put(:friendships, friendships)

    conn |> put_status(:ok) |> json(%{profile: profile_view})
  end
end
