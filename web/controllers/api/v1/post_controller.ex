defmodule PhoenixSocial.PostController do
  use PhoenixSocial.Web, :controller
  use PhoenixSocial.SharedPlugs

  alias PhoenixSocial.{Repo, Post, PostView, FeedChannel}
  alias PhoenixSocial.Params.Pagination
  alias PhoenixSocial.Queries.Wall
  alias PhoenixSocial.Operations.CreatePost

  plug Guardian.Plug.EnsureAuthenticated
  plug Pagination, :pagination when action in [:index]
  plug :scrub_params, "post" when action in [:create, :update]
  plug :find_user when action in [:index, :create]
  plug :find_post when action in [:update, :delete]

  def index(conn, _params) do
    posts =
      conn.assigns[:user]
      |> Wall.posts(conn.assigns[:pagination])
      |> Enum.map(&PostView.render/1)

    conn |> put_status(:ok) |> json(%{posts: posts})
  end

  def create(conn, %{"post" => %{"text" => text}}) do
    user = conn.assigns[:user]
    author = conn.assigns[:current_user]

    case CreatePost.call(user, author, text) do
      {:ok, post} ->
        post_view = PostView.render(post)
        conn |> put_status(:created) |> json(%{post: post_view})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  def update(conn, %{"post" => post_params}) do
    changeset = Post.changeset(conn.assigns[:post], post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        FeedChannel.notify(post, "edited")
        conn |> put_status(:ok) |> json(%{post: PostView.render(post)})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  def delete(conn, _params) do
    case Repo.delete(conn.assigns[:post]) do
      {:ok, _} ->
        FeedChannel.notify(conn.assigns[:post], "deleted")
        conn |> put_status(:ok) |> json(%{result: :ok})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  defp find_post(conn, _) do
    post = Repo.get(Post, conn.params["id"])

    cond do
      is_nil(post) ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})
        |> halt
      conn.assigns[:current_user].id in [post.user_id, post.author_id] ->
        conn
        |> assign(:post, post)
      true ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Forbidden"})
        |> halt
    end
  end
end