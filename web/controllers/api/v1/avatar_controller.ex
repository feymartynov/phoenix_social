require IEx
defmodule PhoenixSocial.AvatarController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{User, Avatar}

  plug Guardian.Plug.EnsureAuthenticated

  def create(conn, %{"avatar" => upload}) do
    changeset = User.update_avatar(conn.assigns[:current_user], upload["path"])

    if changeset.valid? do
      user = Repo.update!(changeset)

      conn
      |> put_status(:created)
      |> json(Avatar.urls({user.avatar, user}))
    else
      errors = User.error_messages(changeset)
      conn |> respond_with_error(errors)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns[:current_user]
    changeset = User.update_avatar(user, nil)

    if changeset.valid? do
      :ok = Avatar.delete({user.avatar.file_name, user})
      Repo.update!(changeset)
      conn |> put_status(:no_content) |> json(nil)
    else
      errors = User.error_messages(changeset)
      conn |> respond_with_error(errors)
    end
  end
end
