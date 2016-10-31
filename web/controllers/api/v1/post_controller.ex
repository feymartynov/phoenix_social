defmodule PhoenixSocial.PostController do
  use PhoenixSocial.Web, :controller
  import PhoenixSocial.SharedPlugs, only: [find_profile: 2]

  alias PhoenixSocial.{Repo, Post, PostView, PostChannel}
  alias PhoenixSocial.Params.Pagination
  alias PhoenixSocial.Queries.Wall
  alias PhoenixSocial.Operations.CreatePost

  plug Guardian.Plug.EnsureAuthenticated
  plug Pagination, :pagination when action in [:index]
  plug :scrub_params, "post" when action in [:create, :update]
  plug :find_profile, [authorize: false] when action in [:index, :create]
  plug :find_post when action in [:update, :delete]

  def index(conn, _params) do
    posts =
      conn.assigns.profile
      |> Wall.posts(conn.assigns.pagination)
      |> Enum.map(&PostView.render/1)

    conn |> put_status(:ok) |> json(%{posts: posts})
  end

  def create(conn, %{"post" => %{"text" => text}}) do
    profile = conn.assigns.profile
    author = conn.assigns.current_user

    case CreatePost.call(profile, author, text) do
      {:ok, post} ->
        post_view = handle_success(post, "post:added")
        conn |> put_status(:created) |> json(%{post: post_view})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  def update(conn, %{"post" => post_params}) do
    changeset = Post.changeset(conn.assigns.post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        post_view = handle_success(post, "post:edited")
        conn |> put_status(:ok) |> json(%{post: post_view})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  def delete(conn, _params) do
    case Repo.delete(conn.assigns.post) do
      {:ok, _} ->
        handle_success(conn.assigns.post, "post:deleted")
        conn |> put_status(:ok) |> json(%{result: :ok})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  defp find_post(conn, _) do
    post = Repo.get(Post, conn.params["id"])
    current_user = conn.assigns.current_user

    cond do
      is_nil(post) ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})
        |> halt
      post.profile_id == current_user.profile.id ||
      post.author_id == current_user.id ->
        conn |> assign(:post, post)
      true ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Forbidden"})
        |> halt
    end
  end

  defp handle_success(post, event) do
    assocs = [comments: [author: :profile], author: :profile]
    post = post |> Repo.preload(assocs)
    PostChannel.notify(post, event)
    PostView.render(post)
  end
end
