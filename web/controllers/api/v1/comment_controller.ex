defmodule PhoenixSocial.CommentController do
  use PhoenixSocial.Web, :controller

  alias PhoenixSocial.{Repo, Comment, Post, CommentView, PostChannel}

  plug Guardian.Plug.EnsureAuthenticated
  plug :scrub_params, "comment" when action in [:create, :update]
  plug :find_comment when action in [:update, :delete]
  plug :find_post when action in [:create]
  plug :authorize_update when action in [:update]
  plug :authorize_deletion when action in [:delete]

  def create(conn, %{"comment" => comment_params}) do
    comment =
      %Comment{
        post: conn.assigns.post,
        author: conn.assigns.current_user.profile}

    changeset = Comment.changeset(comment, comment_params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        comment = comment |> Repo.preload(:author)
        PostChannel.notify(comment, "comment:added")
        comment_view = CommentView.render(comment)
        conn |> put_status(:created) |> json(%{comment: comment_view})
      {:error, changeset} ->
        error = Comment.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  def update(conn, %{"comment" => comment_params}) do
    changeset = Comment.changeset(conn.assigns.comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        comment = comment |> Repo.preload(:author)
        PostChannel.notify(comment, "comment:edited")
        comment_view = CommentView.render(comment)
        conn |> put_status(:ok) |> json(%{comment: comment_view})
      {:error, changeset} ->
        error = Comment.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  defp authorize_update(conn, _) do
    if conn.assigns.current_user.profile.id == conn.assigns.comment.author_id do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Forbidden"})
      |> halt
    end
  end

  def delete(conn, _params) do
    case Repo.delete(conn.assigns.comment) do
      {:ok, _} ->
        comment = conn.assigns.comment |> Repo.preload(:author)
        PostChannel.notify(comment, "comment:deleted")
        conn |> put_status(:ok) |> json(%{result: :ok})
      {:error, changeset} ->
        error = Comment.error_messages(changeset)
        conn |> respond_with_error(error)
    end
  end

  defp authorize_deletion(conn, _) do
    comment = conn.assigns.comment |> Repo.preload(:post)
    current_user = conn.assigns.current_user
    authorized_profiles = [comment.author_id, comment.post.profile_id]

    if current_user.profile.id in authorized_profiles do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Forbidden"})
      |> halt
    end
  end

  defp find_comment(conn, _) do
    if comment = Repo.get(Comment, conn.params["id"]) do
      comment = comment |> Repo.preload(:post)
      conn |> assign(:comment, comment)
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "Comment not found"})
      |> halt
    end
  end

  defp find_post(conn, _) do
    case Repo.get(Post, conn.params["post_id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})
        |> halt
      post ->
        conn |> assign(:post, post)
    end
  end
end
