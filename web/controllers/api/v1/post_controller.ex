defmodule PhoenixSocial.PostController do
  use PhoenixSocial.Web, :controller
  use PhoenixSocial.SharedPlugs

  alias PhoenixSocial.{Repo, Post, PostView}
  alias PhoenixSocial.PostController.{IndexParams}
  alias PhoenixSocial.Operations.{CreatePost}

  plug Guardian.Plug.EnsureAuthenticated
  plug :scrub_params, "post" when action in [:create, :update]
  plug :find_user when action in [:index, :create]
  plug :find_post when action in [:update, :delete]
  plug :validate_index_params when action in [:index]

  def index(conn, _params) do
    posts = conn |> index_query |> Repo.all |> Enum.map(&PostView.render/1)
    conn |> put_status(:ok) |> json(%{posts: posts})
  end

  defp validate_index_params(conn, _) do
    changeset = IndexParams.changeset(%IndexParams{}, conn.params)

    if changeset.valid? do
      validated_params = Map.merge(%IndexParams{}, changeset.changes)
      conn |> assign(:validated_params, validated_params)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{error: Post.error_messages(changeset)})
      |> halt
    end
  end

  defp index_query(conn) do
    from Post,
      where: [user_id: ^conn.assigns[:user].id],
      order_by: [desc: :inserted_at],
      offset: ^conn.assigns[:validated_params].offset,
      limit: ^conn.assigns[:validated_params].limit
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
        conn |> put_status(:ok) |> json(%{post: PostView.render(post)})
      {:error, changeset} ->
        error = Post.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  def delete(conn, _params) do
    case Repo.delete(conn.assigns[:post]) do
      {:ok, _} ->
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
      post.user_id != conn.assigns[:current_user].id ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Forbidden"})
        |> halt
      true ->
        conn
        |> assign(:post, post)
    end
  end
end