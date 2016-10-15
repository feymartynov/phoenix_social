defmodule PhoenixSocial.AvatarController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{User, Avatar, UserView}

  plug Guardian.Plug.EnsureAuthenticated

  def create(conn, %{"avatar" => upload}) do
    changeset =
      conn.assigns[:current_user]
      |> User.update_avatar(upload.path)

    if changeset.valid? do
      user = Repo.update!(changeset)

      conn
      |> put_status(:created)
      |> json(%{user: UserView.render(user, as: user)})
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
      user = Repo.update!(changeset)

      conn
      |> put_status(:ok)
      |> json(%{user: UserView.render(user, as: user)})
    else
      errors = User.error_messages(changeset)
      conn |> respond_with_error(errors)
    end
  end
end
