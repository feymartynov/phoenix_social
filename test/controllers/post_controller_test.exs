defmodule PhoenixSocial.PostControllerTest do
  use PhoenixSocial.ConnCase

  test "List user's posts'" do
    user = insert(:user)
    posts = insert_list(2, :post, user: user, author: user)
    _unrelated_post = insert(:post)

    assert {200, json} = api_call(:get, "/users/#{user.id}/posts", as: user)

    ids = Enum.map(json["posts"], &(&1["id"]))
    expected_ids = Enum.map(posts, &(&1.id)) |> Enum.reverse
    assert ids == expected_ids

    texts = Enum.map(json["posts"], &(&1["text"]))
    expected_texts = Enum.map(posts, &(&1.text)) |> Enum.reverse
    assert texts == expected_texts
  end

  test "List another user's posts" do
    user = insert(:user)
    _unrelated_post = insert(:post, user: user, author: user)

    other_user = insert(:user)
    posts = insert_list(2, :post, user: other_user)

    url = "/users/#{other_user.id}/posts"
    assert {200, json} = api_call(:get, url, as: user)

    ids = Enum.map(json["posts"], &(&1["id"]))
    expected_ids = Enum.map(posts, &(&1.id)) |> Enum.reverse
    assert ids == expected_ids
  end

  test "List posts with pagination" do
    user = insert(:user)
    posts = insert_list(3, :post, user: user, author: user)

    url = "/users/#{user.id}/posts?offset=1&limit=1"
    assert {200, json} = api_call(:get, url, as: user)
    assert json["posts"] |> length == 1

    post = json["posts"] |> List.first
    assert post["id"] == posts |> Enum.at(1) |> Map.fetch!(:id)
  end

  test "Trying to specify a big limit" do
    user = insert(:user)
    url = "/users/#{user.id}/posts?limit=1000"
    assert {422, json} = api_call(:get, url, as: user)
    assert json["error"]["limit"] |> List.first == "must be less than or equal to 100"
  end

  test "Trying to specify a zero limit" do
    user = insert(:user)
    url = "/users/#{user.id}/posts?limit=0"
    assert {422, json} = api_call(:get, url, as: user)
    assert json["error"]["limit"] |> List.first == "must be greater than or equal to 1"
  end

  test "Trying to specify wrong limit" do
    user = insert(:user)
    url = "/users/#{user.id}/posts?limit=abcd"
    assert {422, json} = api_call(:get, url, as: user)
    assert json["error"]["limit"] |> List.first == "is invalid"
  end

  test "Trying to specify wrong offset" do
    user = insert(:user)
    url = "/users/#{user.id}/posts?offset=-5"
    assert {422, json} = api_call(:get, url, as: user)
    assert json["error"]["offset"] |> List.first == "must be greater than or equal to 0"
  end

  test "Create a post" do
    user = insert(:user)
    url = "/users/#{user.id}/posts"
    body = %{"post" => %{"text" => "Hello world"}}
    assert {201, json} = api_call(:post, url, body: body, as: user)
    assert json["post"]["text"] == "Hello world"
    assert json["post"]["user_id"] == user.id
    assert json["post"]["author"]["id"] == user.id
  end

  test "Trying to create a post with wrong params" do
    user = insert(:user)
    url = "/users/#{user.id}/posts"
    body = %{"post" => %{"text" => ""}}
    assert {422, json} = api_call(:post, url, body: body, as: user)
    assert json["error"]["text"] |> List.first == "can't be blank"
  end

  test "Allow posting to friend's wall" do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    url = "/users/#{friend.id}/posts"
    body = %{"post" => %{"text" => "Hello world"}}
    assert {201, _} = api_call(:post, url, body: body, as: user)
  end

  test "Reject posting to non-friend's wall" do
    user = insert(:user)
    other_user = insert(:user, first_name: "Elvis", last_name: "Presley")

    url = "/users/#{other_user.id}/posts"
    body = %{"post" => %{"text" => "Hello world"}}
    assert {422, json} = api_call(:post, url, body: body, as: user)
    assert json["error"]["author"] == ["is not a friend of Elvis Presley"]
  end

  test "Reject posting to the wall when rejected by a friend" do
    user = insert(:user)
    friend = insert(:user, first_name: "Elvis", last_name: "Presley")
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "rejected")

    url = "/users/#{friend.id}/posts"
    body = %{"post" => %{"text" => "Hello world"}}
    assert {422, json} = api_call(:post, url, body: body, as: user)
    assert json["error"]["author"] == ["is not a friend of Elvis Presley"]
  end

  test "Update a post" do
    user = insert(:user)
    post = insert(:post, text: "old text", user: user, author: user)
    url = "/posts/#{post.id}"
    body = %{"post" => %{"text" => "new text"}}
    assert {200, json} = api_call(:put, url, body: body, as: user)
    assert json["post"]["text"] == "new text"
  end

  test "Trying to update a post with wrong params" do
    user = insert(:user)
    post = insert(:post, text: "old text", user: user, author: user)
    url = "/posts/#{post.id}"
    body = %{"post" => %{"text" => ""}}
    assert {422, json} = api_call(:put, url, body: body, as: user)
    assert json["error"]["text"] |> List.first == "can't be blank"
  end

  test "Trying to update someone else's post" do
    post = insert(:post, text: "old text")
    url = "/posts/#{post.id}"
    body = %{"post" => %{"text" => "new text"}}
    assert {403, json} = api_call(:put, url, body: body, as: insert(:user))
    assert json["error"] == "Forbidden"
  end

  test "Delete a post" do
    user = insert(:user)
    post = insert(:post, user: user, author: user)
    url = "/posts/#{post.id}"
    assert {200, json} = api_call(:delete, url, as: user)
    assert json["result"] == "ok"
  end

  test "Trying to delete someone else's post" do
    post = insert(:post)
    url = "/posts/#{post.id}"
    assert {403, json} = api_call(:delete, url, as: insert(:user))
    assert json["error"] == "Forbidden"
  end

  test "Delete someone else's post on own wall" do
    user = insert(:user)
    post = insert(:post, user: user)
    url = "/posts/#{post.id}"
    assert {200, json} = api_call(:delete, url, as: user)
    assert json["result"] == "ok"
  end
end
