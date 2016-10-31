defmodule PhoenixSocial.AvatarController do
  use PhoenixSocial.Web, :controller
  import PhoenixSocial.SharedPlugs, only: [find_profile: 2]

  alias PhoenixSocial.{Profile, Avatar, ProfileView}

  plug Guardian.Plug.EnsureAuthenticated
  plug :find_profile

  def create(conn, %{"avatar" => upload}) do
    changeset = conn.assigns.profile |> Profile.update_avatar(upload.path)

    if changeset.valid? do
      profile = Repo.update!(changeset)

      conn
      |> put_status(:created)
      |> json(%{profile: ProfileView.render(profile)})
    else
      errors = Profile.error_messages(changeset)
      conn |> respond_with_error(errors)
    end
  end

  def delete(conn, _params) do
    profile = conn.assigns.profile
    changeset = profile |> Profile.update_avatar(nil)

    if changeset.valid? do
      :ok = Avatar.delete({profile.avatar.file_name, profile})
      profile = Repo.update!(changeset)

      conn
      |> put_status(:ok)
      |> json(%{profile: ProfileView.render(profile)})
    else
      errors = Profile.error_messages(changeset)
      conn |> respond_with_error(errors)
    end
  end
end
