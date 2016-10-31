defmodule PhoenixSocial.PostChannel do
  use PhoenixSocial.Web, :channel

  alias PhoenixSocial.{Endpoint, Repo, PostView, CommentView}
  alias PhoenixSocial.Queries.Feed

  def join("feed", _params, socket), do: {:ok, socket}
  def join("wall:" <> _, _params, socket), do: {:ok, socket}

  def notify(post, event = "post:" <> _) do
    post = post |> Repo.preload(:author)
    Endpoint.broadcast "wall:#{post.profile_id}", event, post
    Endpoint.broadcast "feed", event, post
  end
  def notify(comment, event = "comment:" <> _) do
    comment = comment |> Repo.preload(post: :author)
    Endpoint.broadcast "wall:#{comment.post.profile_id}", event, comment
    Endpoint.broadcast "feed", event, comment
  end

  intercept ~w(
    post:added post:edited post:deleted
    comment:added comment:edited comment:deleted)

  def handle_out(event = "post:" <> _, post, socket) do
    if should_notify?(socket, post) do
      push(socket, event, payload(post, event))
    end

    {:noreply, socket}
  end
  def handle_out(event = "comment:" <> _, comment, socket) do
    if should_notify?(socket, comment.post) do
      push(socket, event, payload(comment, event))
    end

    {:noreply, socket}
  end

  defp should_notify?(socket, post) do
    case socket.topic do
      "feed" ->
        Feed.belongs_to_feed?(post, socket.assigns.current_user)
      "wall:" <> _ ->
        true
    end
  end

  defp payload(post, "post:" <> _) do
    %{post: PostView.render(post)}
  end
  defp payload(comment, "comment:" <> _) do
    %{comment: CommentView.render(comment)}
  end
end
