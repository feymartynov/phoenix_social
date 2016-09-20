defmodule PhoenixSocial.FriendControllerTest do
  use PhoenixSocial.ConnCase

  defp assert_has_friend(user, friend, expected_state) do
    assert {200, json} = api_call(:get, "/users/current", as: user)

    friend_info = json["user"]["friends"] |> List.first
    assert friend_info["id"] == friend.id
    assert friend_info["friendship_state"] == expected_state
  end

  test "Add a user to friends" do
    {user, friend} = {insert(:user), insert(:user)}

    body = %{"user_id" => friend.id}
    assert {201, json} = api_call(:post, "/friends", body: body, as: user)
    assert json["result"] == "John Doe added to friends"
    assert_has_friend(user, friend, "confirmed")
    assert_has_friend(friend, user, "pending")
  end

  test "Confirm friendship" do
    {user, friend} = {insert(:user), insert(:user)}
    api_call(:post, "/friends", body: %{"user_id" => friend.id}, as: user)
    assert_has_friend(friend, user, "pending")

    body = %{"user_id" => user.id}
    assert {200, json} = api_call(:post, "/friends", body: body, as: friend)
    assert json["result"] == "Friendship with John Doe confirmed"
    assert_has_friend(friend, user, "confirmed")
  end

  test "Try adding someone to friends twice" do
    {user, friend} = {insert(:user), insert(:user)}
    body = %{"user_id" => friend.id}

    api_call(:post, "/friends", body: body, as: user)

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

  test "Delete a friend" do
    {user, friend} = {insert(:user), insert(:user)}
    api_call(:post, "/friends", body: %{"user_id" => friend.id}, as: user)

    assert {200, json} = api_call(:delete, "/friends/#{friend.id}", as: user)
    assert json["result"] == "John Doe deleted from friends"
    assert_has_friend(user, friend, "rejected")
  end

  test "Try deleting a non-friend from friends" do
    user = insert(:user)

    assert {404, json} = api_call(:delete, "/friends/123456789", as: user)
    assert json["result"] == "Friend not found"
  end
end
