defmodule PhoenixSocial.FeedChannel do
  use PhoenixSocial.Web, :channel

  alias PhoenixSocial.{Endpoint, PostView}
  alias PhoenixSocial.Queries.Feed

  def join("feed", _params, socket), do: {:ok, socket}

  def notify(post, event), do: Endpoint.broadcast "feed", "post:#{event}", post

  intercept ~w(post:added post:edited post:deleted)

  def handle_out(event, post, socket) do
    if Feed.belongs_to_feed?(post, socket.assigns[:current_user]) do
      push(socket, event, payload(post, event))
    end

    {:noreply, socket}
  end

  defp payload(post, "post:deleted"), do: %{id: post.id}
  defp payload(post, event) when event in ~w(post:added post:edited) do
    %{post: PostView.render(post)}
  end
end
