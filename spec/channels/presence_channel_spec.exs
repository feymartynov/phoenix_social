defmodule PhoenixSocial.PresenceChannelSpec do
  use ESpec.Phoenix, channel: PresenceChannel

  alias PhoenixSocial.{PresenceChannel, Repo}

  let :user, do: insert(:user)
  let :user_socket, do: socket("users:#{user.id}", %{current_user: user})

  defp join(user) do
    user = user |> Repo.preload(:friendships)

    {:ok, _, user_socket} =
      socket("users:#{user.id}", %{current_user: user})
      |> subscribe_and_join(PresenceChannel, "presence")

    user_socket
  end

  context "with a friend" do
    let :friend, do: insert(:user)

    before do
      insert(:friendship, user1: user, user2: friend, state: "confirmed")
      insert(:friendship, user1: friend, user2: user, state: "confirmed")
    end

    it "pushes initial state on join" do
      friend |> join
      user |> join

      id = friend.id |> to_string
      assert_push "presence_state", %{^id => _}
    end

    it "pushes diff when the friend joins" do
      user |> join
      friend |> join

      id = friend.id |> to_string
      assert_push "presence_diff", %{joins: %{^id => _}}
    end

    it "pushes diff when the friend leaves" do
      user |> join

      friend_socket = friend |> join
      Process.unlink(friend_socket.channel_pid)
      friend_socket |> leave

      id = friend.id |> to_string
      assert_push "presence_diff", %{leaves: %{^id => _}}
    end
  end

  context "with another user" do
    let :other_user, do: insert(:user)

    it "doesn't push diff when the other joins" do
      user |> join
      other_user |> join

      id = other_user.id |> to_string
      refute_push "presence_diff", %{joins: %{^id => _}}
    end
  end
end
