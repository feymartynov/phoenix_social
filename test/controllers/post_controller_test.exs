defmodule PhoenixSocial.PostControllerTest do
  use PhoenixSocial.ConnCase

  test "List user's posts'" do
    user = insert(:user)
    posts = insert_list(2, :post, user: user)
    _unrelated_post = insert(:post)

    assert {200, json} = api_call(:get, "/posts", as: user)

    ids = Enum.map(json["posts"], &(&1["id"]))
    expected_ids = Enum.map(posts, &(&1.id)) |> Enum.reverse
    assert ids == expected_ids

    texts = Enum.map(json["posts"], &(&1["text"]))
    expected_texts = Enum.map(posts, &(&1.text)) |> Enum.reverse
    assert texts == expected_texts
  end

  test "List posts with pagination" do
    user = insert(:user)
    posts = insert_list(3, :post, user: user)

    url = "/posts?offset=1&limit=1"
    assert {200, json} = api_call(:get, url, as: user)
    assert json["posts"] |> length == 1

    post = json["posts"] |> List.first
    assert post["id"] == posts |> Enum.at(1) |> Map.fetch!(:id)
  end

  test "Trying to specify a big limit" do
    assert {422, json} = api_call(:get, "/posts?limit=1000", as: insert(:user))
    assert json["error"]["limit"] |> List.first == "must be less than or equal to 100"
  end

  test "Trying to specify a zero limit" do
    assert {422, json} = api_call(:get, "/posts?limit=0", as: insert(:user))
    assert json["error"]["limit"] |> List.first == "must be greater than or equal to 1"
  end

  test "Trying to specify wrong limit" do
    assert {422, json} = api_call(:get, "/posts?limit=abcd", as: insert(:user))
    assert json["error"]["limit"] |> List.first == "is invalid"
  end

  test "Trying to specify wrong offset" do
    assert {422, json} = api_call(:get, "/posts?offset=-5", as: insert(:user))
    assert json["error"]["offset"] |> List.first == "must be greater than or equal to 0"
  end

  test "Create a post" do
    user = insert(:user)
    body = %{"post" => %{"text" => "Hello world"}}
    assert {201, json} = api_call(:post, "/posts", body: body, as: user)
    assert json["post"]["text"] == "Hello world"
    assert json["post"]["user_id"] == user.id
  end

  test "Trying to create a post with wrong params" do
    user = insert(:user)
    body = %{"post" => %{"text" => ""}}
    assert {422, json} = api_call(:post, "/posts", body: body, as: user)
    assert json["error"]["text"] |> List.first == "can't be blank"
  end

  test "Update a post" do
    post = insert(:post, text: "old text")
    url = "/posts/#{post.id}"
    body = %{"post" => %{"text" => "new text"}}
    assert {200, json} = api_call(:put, url, body: body, as: post.user)
    assert json["post"]["text"] == "new text"
  end

  test "Trying to update a post with wrong params" do
    post = insert(:post, text: "old text")
    url = "/posts/#{post.id}"
    body = %{"post" => %{"text" => ""}}
    assert {422, json} = api_call(:put, url, body: body, as: post.user)
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
    post = insert(:post)
    url = "/posts/#{post.id}"
    assert {200, json} = api_call(:delete, url, as: post.user)
    assert json["result"] == "ok"
  end

  test "Trying to delete someone else's post" do
    post = insert(:post)
    url = "/posts/#{post.id}"
    assert {403, json} = api_call(:delete, url, as: insert(:user))
    assert json["error"] == "Forbidden"
  end
end