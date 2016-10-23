defmodule PhoenixSocial.FeedController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.PostView
  alias PhoenixSocial.Params.Pagination
  alias PhoenixSocial.Queries.Feed

  plug Guardian.Plug.EnsureAuthenticated
  plug Pagination, :pagination

  def show(conn, _params) do
    posts =
      conn.assigns[:current_user]
      |> Feed.posts(conn.assigns[:pagination])
      |> Enum.map(&PostView.render/1)

    conn |> json(%{posts: posts})
  end
end
