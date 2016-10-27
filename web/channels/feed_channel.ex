defmodule PhoenixSocial.FeedChannel do
  use PhoenixSocial.Web, :channel

  alias PhoenixSocial.{Endpoint, PostView, CommentView}
  alias PhoenixSocial.Queries.Feed

  def join("feed", _params, socket), do: {:ok, socket}

  def notify(post, event), do: Endpoint.broadcast "feed", event, post

  intercept ~w(
    post:added post:edited post:deleted
    comment:added comment:edited comment:deleted)

  def handle_out(event = "post:" <> _, post, socket) do
    if Feed.belongs_to_feed?(post, socket.assigns[:current_user]) do
      push(socket, event, payload(post, event))
    end

    {:noreply, socket}
  end
  def handle_out(event = "comment:" <> _, comment, socket) do
    if Feed.belongs_to_feed?(comment.post, socket.assigns[:current_user]) do
      push(socket, event, payload(comment, event))
    end

    {:noreply, socket}
  end

  defp payload(post, "post:" <> _) do
    %{post: PostView.render(post)}
  end
  defp payload(comment, "comment:" <> _) do
    %{comment: CommentView.render(comment)}
  end
end
