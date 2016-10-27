defmodule PhoenixSocial.CommentControllerTest do
  use PhoenixSocial.ConnCase

  test "Create a comment" do
    user = insert(:user)
    post = insert(:post)
    url = "/posts/#{post.id}/comments"
    body = %{"comment" => %{"text" => "Hello world"}}
    assert {201, json} = api_call(:post, url, body: body, as: user)
    assert json["comment"]["text"] == "Hello world"
    assert json["comment"]["post_id"] == post.id
    assert json["comment"]["author"]["id"] == user.id
  end

  test "Trying to create a post with wrong params" do
    user = insert(:user)
    post = insert(:post)
    url = "/posts/#{post.id}/comments"
    body = %{"comment" => %{"text" => ""}}
    assert {422, json} = api_call(:post, url, body: body, as: user)
    assert json["error"]["text"] |> List.first == "can't be blank"
  end

  test "Update a comment" do
    user = insert(:user)
    comment = insert(:comment, text: "old text", author: user)
    url = "/comments/#{comment.id}"
    body = %{"comment" => %{"text" => "new text"}}
    assert {200, json} = api_call(:put, url, body: body, as: user)
    assert json["comment"]["text"] == "new text"
  end

  test "Trying to update a comment with wrong params" do
    user = insert(:user)
    comment = insert(:comment, text: "old text", author: user)
    url = "/comments/#{comment.id}"
    body = %{"comment" => %{"text" => ""}}
    assert {422, json} = api_call(:put, url, body: body, as: user)
    assert json["error"]["text"] |> List.first == "can't be blank"
  end

  test "Trying to update someone else's comment" do
    comment = insert(:comment)
    url = "/comments/#{comment.id}"
    body = %{"comment" => %{"text" => "new text"}}
    assert {403, json} = api_call(:put, url, body: body, as: insert(:user))
    assert json["error"] == "Forbidden"
  end

  test "Delete a comment" do
    user = insert(:user)
    comment = insert(:comment, author: user)
    url = "/comments/#{comment.id}"
    assert {200, json} = api_call(:delete, url, as: user)
    assert json["result"] == "ok"
  end

  test "Trying to delete someone else's comment" do
    comment = insert(:comment)
    url = "/comments/#{comment.id}"
    assert {403, json} = api_call(:delete, url, as: insert(:user))
    assert json["error"] == "Forbidden"
  end

  test "Delete someone else's post on own wall" do
    user = insert(:user)
    post = insert(:post, user: user)
    comment = insert(:comment, post: post, author: insert(:user))
    url = "/comments/#{comment.id}"
    assert {200, json} = api_call(:delete, url, as: user)
    assert json["result"] == "ok"
  end
end
