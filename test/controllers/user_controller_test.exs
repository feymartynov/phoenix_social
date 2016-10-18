defmodule PhoenixSocial.UserControllerTest do
  use PhoenixSocial.ConnCase

  test "Register a user" do
    body = %{
      "user" => %{
        "email" => "johndoe@example.com",
        "first_name" => "John",
        "last_name" => "Doe",
        "password" => "12345",
        "password_confirmation" => "12345" }}

    assert {201, json} = api_call(:post, "/users", body: body)
    assert json["user"]["id"] |> is_integer
    assert json["user"]["first_name"] == "John"
    assert json["user"]["last_name"] == "Doe"
    assert json["jwt"] |> is_binary
  end

  test "Fail registration" do
    body = %{
      "user" => %{
        "first_name" => "John",
        "last_name" => "Doe",
        "password" => "12345",
        "password_confirmation" => "12345678" }}

    assert {422, json} = api_call(:post, "/users", body: body)
    assert json["error"]["email"] |> List.first == "can't be blank"

    confirmation_error = json["error"]["password_confirmation"] |> List.first
    assert confirmation_error == "does not match confirmation"
  end

  test "Update profile" do
    user = insert(:user, city: "St. Petersburg")
    body = %{"user" => %{"city" => "Moscow"}}
    assert {200, json} = api_call(:put, "/users/current", body: body, as: user)
    assert json["user"]["id"] == user.id
    assert json["user"]["city"] == "Moscow"
  end

  test "Fail profile update" do
    user = insert(:user)
    body = %{"user" => %{"birthday" => "0000-12-34"}}
    assert {422, json} = api_call(:put, "/users/current", body: body, as: user)
    assert json["error"]["birthday"] |> List.first == "is invalid"
  end

  test "Trying to update another user" do
    {user, other_user} = {insert(:user), insert(:user)}
    url = "/users/#{user.id}"
    body = %{"user" => %{"city" => "Moscow"}}
    assert {401, json} = api_call(:put, url, body: body, as: other_user)
    assert json["error"] == "Unauthorized"
  end

  test "Show all friends for current user" do
    user = insert(:user)
    insert(:friendship, user1: user, state: "confirmed")
    insert(:friendship, user1: user, state: "pending")

    assert {200, json} = api_call(:get, "/users/current", as: user)
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

  test "Trying to show not found user" do
    assert {404, json} = api_call(:get, "/users/0123")
    assert json["error"] == "User not found"
  end
end
