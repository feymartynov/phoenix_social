defmodule PhoenixSocial.UserView do
  use PhoenixSocial.Web, :view

  def render("show.json", %{user: user}) do
    %{user: user}
  end

  def render("create.json", %{jwt: jwt, user: user}) do
    %{jwt: jwt, user: user}
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: error_messages(changeset)}
  end
end
