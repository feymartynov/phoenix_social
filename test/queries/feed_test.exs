defmodule PhoenixSocial.Queries.FeedTest do
  use PhoenixSocial.ModelCase

  alias PhoenixSocial.Repo
  alias PhoenixSocial.Queries.Feed

  test "Allows own post to the feed" do
    user = insert(:user)
    post = insert(:post, user: insert(:user), author: user)
    assert Feed.belongs_to_feed?(post, user)
  end

  test "Allows a post from own wall to the feed" do
    user = insert(:user)
    post = insert(:post, user: user, author: insert(:user))
    assert Feed.belongs_to_feed?(post, user)
  end

  test "Forbids unrelated post to the feed" do
    assert !Feed.belongs_to_feed?(insert(:post), insert(:user))
  end

  test "Allows a friend's post on his wall to the feed" do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    user = user |> Repo.preload(:friendships)
    post = insert(:post, user: friend, author: friend)
    assert Feed.belongs_to_feed?(post, user)
  end

  test "Forbids a rejected friend's post on his wall to the feed" do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "rejected")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    user = user |> Repo.preload(:friendships)
    post = insert(:post, user: friend, author: friend)
    assert !Feed.belongs_to_feed?(post, user)
  end

  test "Forbids a friend's post on someone else's wall to the feed" do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    user = user |> Repo.preload(:friendships)
    post = insert(:post, user: insert(:user), author: friend)
    assert !Feed.belongs_to_feed?(post, user)
  end
end
