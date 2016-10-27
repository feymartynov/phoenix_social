defmodule PhoenixSocial.FeedChannelTest do
  use PhoenixSocial.ChannelCase

  alias PhoenixSocial.FeedChannel

  setup do
    user = insert(:user)

    {:ok, _, _} =
      socket("users:#{user.id}", %{current_user: user})
      |> subscribe_and_join(FeedChannel, "feed")

    {:ok, user: user}
  end

  test "Pushes a new post into the feed", %{user: user} do
    post = insert(:post, user: user, author: user)
    post |> FeedChannel.notify("post:added")
    id = post.id
    assert_push "post:added", %{post: %{id: ^id}}
  end

  test "Doesn't push unrelated posts into the feed" do
    insert(:post) |> FeedChannel.notify("post:added")
    refute_push "post:added", %{post: _}
  end

  test "Pushes post update into the feed", %{user: user} do
    post = insert(:post, user: user, author: user)
    post |> FeedChannel.notify("post:edited")
    id = post.id
    assert_push "post:edited", %{post: %{id: ^id}}
  end

  test "Pushes post deletion into the feed", %{user: user} do
    post = insert(:post, user: user, author: user)
    post |> FeedChannel.notify("post:deleted")
    id = post.id
    assert_push "post:deleted", %{post: %{id: ^id}}
  end

  test "Pushes a new comment into the feed", %{user: user} do
    post = insert(:post, user: user)
    comment = insert(:comment, post: post)
    comment |> FeedChannel.notify("comment:added")
    id = comment.id
    assert_push "comment:added", %{comment: %{id: ^id}}
  end

  test "Doesn't push unrelated comments into the feed" do
    insert(:comment) |> FeedChannel.notify("comment:added")
    refute_push "comment:added", %{comment: _}
  end

  test "Pushes comment update into the feed", %{user: user} do
    post = insert(:post, user: user)
    comment = insert(:comment, post: post)
    comment |> FeedChannel.notify("comment:edited")
    id = comment.id
    assert_push "comment:edited", %{comment: %{id: ^id}}
  end

  test "Pushes comment deletion into the feed", %{user: user} do
    post = insert(:post, user: user)
    comment = insert(:comment, post: post)
    comment |> FeedChannel.notify("comment:deleted")
    id = comment.id
    assert_push "comment:deleted", %{comment: %{id: ^id}}
  end
end
