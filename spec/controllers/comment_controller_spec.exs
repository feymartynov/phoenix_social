defmodule PhoenixSocial.CommentControllerSpec do
  use ESpec.Phoenix, controller: CommentController

  let :user, do: insert(:user)

  describe "#create" do
    let :post, do: insert(:post)
    let :url, do: "/posts/#{post.id}/comments"

    it "creates a comment" do
      body = %{"comment" => %{"text" => "Hello world"}}
      assert {201, json} = api_call(:post, url, body: body, as: user)
      assert json["comment"]["text"] == "Hello world"
      assert json["comment"]["post_id"] == post.id
      assert json["comment"]["author"]["id"] == user.profile.id
    end

    it "doesn't create a post with wrong params" do
      body = %{"comment" => %{"text" => ""}}
      assert {422, json} = api_call(:post, url, body: body, as: user)
      assert json["error"]["text"] |> List.first == "can't be blank"
    end
  end

  describe "#update" do
    it "updates a comment" do
      comment = insert(:comment, text: "old text", author: user.profile)

      url = "/comments/#{comment.id}"
      body = %{"comment" => %{"text" => "new text"}}
      assert {200, json} = api_call(:put, url, body: body, as: user)
      assert json["comment"]["text"] == "new text"
    end

    it "doesn't update a comment with wrong params" do
      comment = insert(:comment, text: "old text", author: user.profile)

      url = "/comments/#{comment.id}"
      body = %{"comment" => %{"text" => ""}}
      assert {422, json} = api_call(:put, url, body: body, as: user)
      assert json["error"]["text"] |> List.first == "can't be blank"
    end

    it "doesn't update someone else's comment" do
      comment = insert(:comment)

      url = "/comments/#{comment.id}"
      body = %{"comment" => %{"text" => "new text"}}
      assert {403, json} = api_call(:put, url, body: body, as: insert(:user))
      assert json["error"] == "Forbidden"
    end
  end

  describe "#delete" do
    it "deletes a comment" do
      comment = insert(:comment, author: user.profile)

      url = "/comments/#{comment.id}"
      assert {200, json} = api_call(:delete, url, as: user)
      assert json["result"] == "ok"
    end

    it "doesn't delete someone else's comment" do
      comment = insert(:comment)

      url = "/comments/#{comment.id}"
      assert {403, json} = api_call(:delete, url, as: insert(:user))
      assert json["error"] == "Forbidden"
    end

    it "deletes someone else's post on own wall" do
      post = insert(:post, profile: user.profile)
      comment = insert(:comment, post: post)

      url = "/comments/#{comment.id}"
      assert {200, json} = api_call(:delete, url, as: user)
      assert json["result"] == "ok"
    end
  end
end
