defmodule PhoenixSocial.FriendControllerTest do
  use PhoenixSocial.ConnCase

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

    friend_info = json["user"]["friends"] |> List.first
    assert friend_info["id"] == friend.id
    assert friend_info["friendship_state"] == expected_state
  end

  defp assert_friendship_states(user, friend, forward_state, backward_state) do
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

  # null -> CoP
  test "Add a user to friends" do
    {user, friend} = {insert(:user), insert(:user)}

    body = %{"user_id" => friend.id}
    assert {201, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "John Doe added to friends"
    assert_has_friend(user, friend, "confirmed")
    assert_has_friend(friend, user, "pending")
  end

  # CoP -> CoCo
  test "Confirm friendship" do
    {user, friend} = insert_friends("confirmed", "pending")
    body = %{"user_id" => user.id}
    assert {200, json} = api_call(:post, "/friends", body: body, as: friend)
    assert json["result"] == "Friendship with John Doe confirmed"
    assert_friendship_states(user, friend, "confirmed", "confirmed")
  end

  # CoR -> CoCo
  test "Add previously removed friend" do
    {user, friend} = insert_friends("rejected", "confirmed")
    body = %{"user_id" => friend.id}
    assert {200, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "Friendship with John Doe confirmed"
    assert_friendship_states(user, friend, "confirmed", "confirmed")
  end

  # RCa -> CoR
  test "Add a friend who requested a friendship before but cancelled" do
    {user, friend} = insert_friends("cancelled", "rejected")
    body = %{"user_id" => friend.id}
    assert {200, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "Friendship with John Doe confirmed"
    assert_friendship_states(user, friend, "confirmed", "rejected")
  end

  # RCa -> CoP
  test "Request friendship after previous request cancellation" do
    {user, friend} = insert_friends("rejected", "cancelled")

    body = %{"user_id" => friend.id}
    assert {200, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "Friendship with John Doe confirmed"
    assert_friendship_states(user, friend, "confirmed", "pending")
  end

  test "Try adding someone to friends twice" do
    friendship = insert(:friendship)
    insert_back_friendship(friendship)
    {user, friend} = {friendship.user1, friendship.user2}

    body = %{"user_id" => friend.id}
    assert {422, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "John Doe has been already added to friends"
  end

  test "Try adding an absent user to friends" do
    user = insert(:user)
    body = %{"user_id" => 123456789}

    assert {404, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "User not found"
  end

  test "Try adding self to friends" do
    user = insert(:user)
    body = %{"user_id" => user.id}

    assert {422, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "Impossible to add oneself to friends"
  end

  # CoCo -> CoR
  test "Unfriend a user" do
    {user, friend} = insert_friends("confirmed", "confirmed")

    assert {200, json} = api_call(:delete, "/friends/#{friend.id}", as: user)
    assert json["result"] == "John Doe deleted from friends"
    assert_friendship_states(user, friend, "rejected", "confirmed")
  end

  # CoP -> RCa
  test "Cancel a friendship request" do
    {user, friend} = insert_friends("confirmed", "pending")

    assert {200, json} = api_call(:delete, "/friends/#{friend.id}", as: user)
    assert json["result"] == "John Doe deleted from friends"
    assert_friendship_states(user, friend, "rejected", "cancelled")
  end

  # CoP -> CoR
  test "Reject a friendship request" do
    {user, friend} = insert_friends("confirmed", "pending")

    assert {200, json} = api_call(:delete, "/friends/#{user.id}", as: friend)
    assert json["result"] == "John Doe deleted from friends"
    assert_friendship_states(user, friend, "confirmed", "rejected")
  end

  test "Try deleting a non-friend from friends" do
    user = insert(:user)

    assert {404, json} = api_call(:delete, "/friends/123456789", as: user)
    assert json["result"] == "Friend not found"
  end
end
