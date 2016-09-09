defmodule PhoenixSocial.SessionView do
  use PhoenixSocial.Web, :view

  def render("show.json", %{jwt: jwt, user: user}), do: %{jwt: jwt, user: user}
  def render("error.json", _), do: %{error: "Invalid email or password"}
  def render("delete.json", _), do: %{ok: true}
end
