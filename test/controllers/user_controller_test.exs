defmodule PhoenixSocial.UserControllerTest do
  use PhoenixSocial.ConnCase

  test "Show all friends for current user" do
    user = insert(:user)
    insert(:friendship, user1: user, state: "confirmed")
    insert(:friendship, user1: user, state: "pending")

    assert {200, json} = api_call(:get, "/users/#{user.id}", as: user)
    assert length(json["user"]["friendships"]) == 2
    states = Enum.map(json["user"]["friendships"], &(&1["state"]))
    assert Enum.sort(states) == ["confirmed", "pending"]
  end

  test "Show only confirmed friends for another user" do
    user = insert(:user)
    insert(:friendship, user1: user, state: "confirmed")
    insert(:friendship, user1: user, state: "pending")

    assert {200, json} = api_call(:get, "/users/#{user.id}", as: insert(:user))
    assert length(json["user"]["friendships"]) == 1
    assert List.first(json["user"]["friendships"])["state"] == "confirmed"
  end
end
