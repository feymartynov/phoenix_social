defmodule PhoenixSocial.FriendControllerSpec do
  use ESpec.Phoenix, controller: FriendController

  defp insert_back_friendship(friendship, opts \\ []) do
    default_attrs = %{
      user1: friendship.user2,
      user2: friendship.user1,
      state: "pending"}

    insert(:friendship, Enum.into(opts, default_attrs))
  end

  defp insert_friends(forward_state, backward_state) do
    friendship = insert(:friendship, state: forward_state)
    insert_back_friendship(friendship, state: backward_state)
    {friendship.user1, friendship.user2}
  end

  defp assert_has_friend(user, friend, expected_state) do
    assert {200, json} = api_call(:get, "/users/current", as: user)

    friend_info = json["user"]["friendships"] |> List.first
    assert friend_info["id"] == friend.id
    assert friend_info["state"] == expected_state
  end

  defp assert_friendship_states(json, user, friend, forward_state, backward_state) do
    assert json["friendship"]["state"] == forward_state
    assert json["friendship"]["back_friendship"]["state"] == backward_state
    assert_has_friend(user, friend, forward_state)
    assert_has_friend(friend, user, backward_state)
  end

  # Allowed friendships states & transitions:
  #
  #  ╔═════> CoP <════╗    Co  – confirmed
  #  ‖        |       ‖    R   – rejected
  #  v        v       v    P   – pending
  # CoCo <=> CoR <-- RCa   Ca  – cancelled
  #           ^
  #           ‖            <═> – forward & back
  #           v            --> – only forward
  #           RR

  describe "#create" do
    # null -> CoP
    it "adds a user to friends" do
      {user, friend} = {insert(:user), insert(:user)}

      body = %{"user_id" => friend.id}
      assert {201, json} = api_call(:post, "/friends", body: body, as: user)
      assert_friendship_states(json, user, friend, "confirmed", "pending")
    end

    # CoP -> CoCo
    it "confirms friendship" do
      {user, friend} = insert_friends("confirmed", "pending")

      body = %{"user_id" => user.id}
      assert {200, json} = api_call(:post, "/friends", body: body, as: friend)
      assert_friendship_states(json, friend, user, "confirmed", "confirmed")
    end

    # CoR -> CoCo
    it "adds previously removed friend" do
      {user, friend} = insert_friends("rejected", "confirmed")

      body = %{"user_id" => friend.id}
      assert {200, json} = api_call(:post, "/friends", body: body, as: user)
      assert_friendship_states(json, user, friend, "confirmed", "confirmed")
    end

    # RCa -> CoR
    it "adds a friend who requested a friendship before but cancelled" do
      {user, friend} = insert_friends("cancelled", "rejected")

      body = %{"user_id" => friend.id}
      assert {200, json} = api_call(:post, "/friends", body: body, as: user)
      assert_friendship_states(json, user, friend, "confirmed", "rejected")
    end

    # RCa -> CoP
    it "requests friendship after previous request cancellation" do
      {user, friend} = insert_friends("rejected", "cancelled")

      body = %{"user_id" => friend.id}
      assert {200, json} = api_call(:post, "/friends", body: body, as: user)
      assert_friendship_states(json, user, friend, "confirmed", "pending")
    end

    it "fails to add someone to friends twice" do
      friendship = insert(:friendship)
      insert_back_friendship(friendship)
      {user, friend} = {friendship.user1, friendship.user2}

      body = %{"user_id" => friend.id}
      assert {422, json} = api_call(:post, "/friends", body: body, as: user)
      assert json["error"] == "Already confirmed"
    end

    it "fails to add an absent user to friends" do
      user = insert(:user)
      body = %{"user_id" => 123456789}

      assert {404, json} = api_call(:post, "/friends", body: body, as: user)
      assert json["error"] == "User not found"
    end

    it "fails to add oneself to friends" do
      user = insert(:user)
      body = %{"user_id" => user.id}

      assert {422, json} = api_call(:post, "/friends", body: body, as: user)
      assert json["error"] == "Impossible to add oneself to friends"
    end
  end

  describe "#delete" do
    # CoCo -> CoR
    it "unfriends a user" do
      {user, friend} = insert_friends("confirmed", "confirmed")

      assert {200, json} = api_call(:delete, "/friends/#{friend.id}", as: user)
      assert_friendship_states(json, user, friend, "rejected", "confirmed")
    end

    # CoP -> RCa
    it "cancels a friendship request" do
      {user, friend} = insert_friends("confirmed", "pending")

      assert {200, json} = api_call(:delete, "/friends/#{friend.id}", as: user)
      assert_friendship_states(json, user, friend, "rejected", "cancelled")
    end

    # CoP -> CoR
    it "rejects a friendship request" do
      {user, friend} = insert_friends("confirmed", "pending")

      assert {200, json} = api_call(:delete, "/friends/#{user.id}", as: friend)
      assert_friendship_states(json, friend, user, "rejected", "confirmed")
    end

    it "fails to delete a non-friend from friends" do
      user = insert(:user)

      assert {404, json} = api_call(:delete, "/friends/123456789", as: user)
      assert json["error"] == "Friend not found"
    end
  end
end
