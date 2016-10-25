defmodule PhoenixSocial.PresenceChannelTest do
  use PhoenixSocial.ChannelCase

  alias PhoenixSocial.{PresenceChannel, Repo}

  defp join(user) do
    user = user |> Repo.preload(:friendships)

    {:ok, _, user_socket} =
      socket("users:#{user.id}", %{current_user: user})
      |> subscribe_and_join(PresenceChannel, "presence")

    user_socket
  end

  setup do
    friendship = insert(:friendship)
    {:ok, user: friendship.user1, friend: friendship.user2}
  end

  test "Pushes initial state on join", %{user: user, friend: friend} do
    friend |> join
    user |> join
    id = "#{friend.id}"
    assert_push "presence_state", %{^id => _}
  end

  test "Pushes diff when the friend joins", %{user: user, friend: friend} do
    user |> join
    friend |> join
    id = "#{friend.id}"
    assert_push "presence_diff", %{joins: %{^id => _}}
  end

  test "Pushes diff when the friend leaves", %{user: user, friend: friend} do
    user |> join
    friend_socket = friend |> join
    Process.unlink(friend_socket.channel_pid)
    friend_socket |> leave
    id = "#{friend.id}"
    assert_push "presence_diff", %{leaves: %{^id => _}}
  end

  test "Doesn't push diff when someone else joins", %{user: user} do
    other_user = insert(:user)
    user |> join
    other_user |> join
    id = "#{other_user.id}"
    refute_push "presence_diff", %{joins: %{^id => _}}
  end
end
