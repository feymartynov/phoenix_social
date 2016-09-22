defmodule PhoenixSocial.FriendControllerTest do
  use PhoenixSocial.ConnCase

  test "Show all friends for current user" do
    user = insert(:user)
    insert(:friendship, user1: user, state: "confirmed")
    insert(:friendship, user1: user, state: "pending")

    assert {200, json} = api_call(:get, "/users/#{user.id}", as: user)
    assert length(json["user"]["friends"]) == 2
    states = Enum.map(json["user"]["friends"], &(&1["friendship_state"]))
    assert Enum.sort(states) == ["confirmed", "pending"]
  end

  test "Show only confirmed friends for another user" do
    user = insert(:user)
    insert(:friendship, user1: user, state: "confirmed")
    insert(:friendship, user1: user, state: "pending")

    assert {200, json} = api_call(:get, "/users/#{user.id}", as: insert(:user))
    assert length(json["user"]["friends"]) == 1
    assert List.first(json["user"]["friends"])["friendship_state"] == "confirmed"
  end
end
