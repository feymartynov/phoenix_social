defmodule PhoenixSocial.PostControllerSpec do
  use ESpec.Phoenix, controller: PostController

  let :user, do: insert(:user)

  let :other_user do
    insert(
      :user,
      profile: build(:profile, first_name: "Elvis", last_name: "Presley"))
  end

  describe "#index" do
    it "shows user's posts'" do
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
  
    it "shows another user's posts" do
      _unrelated_post = insert(:post, user: user, author: user)
      posts = insert_list(2, :post, user: other_user, author: other_user)
  
      url = "/users/#{other_user.id}/posts"
      assert {200, json} = api_call(:get, url, as: user)
  
      ids = Enum.map(json["posts"], &(&1["id"]))
      expected_ids = Enum.map(posts, &(&1.id)) |> Enum.reverse
      assert ids == expected_ids
    end

    it "shows comments within post" do
      comment = insert(:comment)

      url = "/users/#{comment.post.user.id}/posts"
      assert {200, json} = api_call(:get, url, as: comment.post.user)
      first_post = json["posts"] |> List.first
      first_comment = first_post |> Map.fetch!("comments") |> List.first
      assert first_comment["id"] == comment.id
      assert first_comment["text"] == comment.text
      assert first_comment["author"]["id"] == comment.author.id
    end
  
    it "shows posts with pagination" do
      posts = insert_list(3, :post, user: user, author: user)
  
      url = "/users/#{user.id}/posts?offset=1&limit=1"
      assert {200, json} = api_call(:get, url, as: user)
      assert json["posts"] |> length == 1
  
      post = json["posts"] |> List.first
      assert post["id"] == posts |> Enum.at(1) |> Map.fetch!(:id)
    end
  
    it "fails when specifying a big limit" do
      url = "/users/#{user.id}/posts?limit=1000"
      assert {422, json} = api_call(:get, url, as: user)
      assert json["error"]["limit"] |> List.first == "must be less than or equal to 100"
    end
  
    it "fails when specifying a zero limit" do
      url = "/users/#{user.id}/posts?limit=0"
      assert {422, json} = api_call(:get, url, as: user)
      assert json["error"]["limit"] |> List.first == "must be greater than or equal to 1"
    end
  
    it "fails when specifying wrong limit" do
      url = "/users/#{user.id}/posts?limit=abcd"
      assert {422, json} = api_call(:get, url, as: user)
      assert json["error"]["limit"] |> List.first == "is invalid"
    end
  
    it "fails when specifying wrong offset" do
      url = "/users/#{user.id}/posts?offset=-5"
      assert {422, json} = api_call(:get, url, as: user)
      assert json["error"]["offset"] |> List.first == "must be greater than or equal to 0"
    end
  end
  
  describe "#create" do
    it "creates a post" do
      url = "/users/#{user.id}/posts"
      body = %{"post" => %{"text" => "Hello world"}}
      assert {201, json} = api_call(:post, url, body: body, as: user)
      assert json["post"]["text"] == "Hello world"
      assert json["post"]["user_id"] == user.id
      assert json["post"]["author"]["id"] == user.id
    end
  
    it "fails to create a post with wrong params" do
      url = "/users/#{user.id}/posts"
      body = %{"post" => %{"text" => ""}}
      assert {422, json} = api_call(:post, url, body: body, as: user)
      assert json["error"]["text"] |> List.first == "can't be blank"
    end
  
    it "allows posting to friend's wall" do
      insert(:friendship, user1: user, user2: other_user, state: "confirmed")
      insert(:friendship, user1: other_user, user2: user, state: "confirmed")
  
      url = "/users/#{other_user.id}/posts"
      body = %{"post" => %{"text" => "Hello world"}}
      assert {201, _} = api_call(:post, url, body: body, as: user)
    end
  
    it "rejects posting to non-friend's wall" do
      url = "/users/#{other_user.id}/posts"
      body = %{"post" => %{"text" => "Hello world"}}
      assert {422, json} = api_call(:post, url, body: body, as: user)
      assert json["error"]["author"] == ["is not a friend of Elvis Presley"]
    end
  
    it "rejects posting to the wall when rejected by a friend" do
      insert(:friendship, user1: user, user2: other_user, state: "confirmed")
      insert(:friendship, user1: other_user, user2: user, state: "rejected")
  
      url = "/users/#{other_user.id}/posts"
      body = %{"post" => %{"text" => "Hello world"}}
      assert {422, json} = api_call(:post, url, body: body, as: user)
      assert json["error"]["author"] == ["is not a friend of Elvis Presley"]
    end
  end

  describe "#update" do
    it "updates a post" do
      post = insert(:post, text: "old text", user: user, author: user)

      url = "/posts/#{post.id}"
      body = %{"post" => %{"text" => "new text"}}
      assert {200, json} = api_call(:put, url, body: body, as: user)
      assert json["post"]["text"] == "new text"
    end
  
    it "fails to update a post with wrong params" do
      post = insert(:post, text: "old text", user: user, author: user)

      url = "/posts/#{post.id}"
      body = %{"post" => %{"text" => ""}}
      assert {422, json} = api_call(:put, url, body: body, as: user)
      assert json["error"]["text"] |> List.first == "can't be blank"
    end
  
    it "fails to update someone else's post" do
      post = insert(:post, text: "old text")

      url = "/posts/#{post.id}"
      body = %{"post" => %{"text" => "new text"}}
      assert {403, json} = api_call(:put, url, body: body, as: insert(:user))
      assert json["error"] == "Forbidden"
    end
  end
  
  describe "#delete" do
    it "deletes a post" do
      post = insert(:post, user: user, author: user)

      url = "/posts/#{post.id}"
      assert {200, json} = api_call(:delete, url, as: user)
      assert json["result"] == "ok"
    end
  
    it "fails to delete someone else's post" do
      post = insert(:post)

      url = "/posts/#{post.id}"
      assert {403, json} = api_call(:delete, url, as: insert(:user))
      assert json["error"] == "Forbidden"
    end
  
    it "fails someone else's post on own wall" do
      post = insert(:post, user: user)

      url = "/posts/#{post.id}"
      assert {200, json} = api_call(:delete, url, as: user)
      assert json["result"] == "ok"
    end
  end
end
