defmodule PhoenixSocial.PresenceChannel do
  use PhoenixSocial.Web, :channel

  alias PhoenixSocial.Presence

  def join("presence", _, socket) do
    self |> send(:after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.current_user.id, %{
      online: :os.system_time(:milli_seconds)
    })

    push_presence_state(socket)
    {:noreply, socket}
  end

  defp push_presence_state(socket) do
    current_user = socket.assigns.current_user
    presence = Presence.list(socket) |> filter_for(current_user)

    if presence != %{} do
      push socket, "presence_state", presence
    end
  end

  intercept ["presence_diff"]

  def handle_out("presence_diff", diff, socket) do
    user = socket.assigns.current_user
    diff = Map.new(for {k, v} <- diff, do: {k, v |> filter_for(user)})

    if diff.joins != %{} || diff.leaves != %{} do
      push(socket, "presence_diff", diff)
    end

    {:noreply, socket}
  end

  defp filter_for(presence, user) do
    friend_ids =
      for friendship <- user.friendships do
        friendship.user2_id |> Integer.to_string
      end

    presence |> Map.take(friend_ids)
  end
end
