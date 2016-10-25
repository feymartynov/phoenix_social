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
    post |> FeedChannel.notify("added")
    id = post.id
    assert_push "post:added", %{post: %{id: ^id}}
  end

  test "Doesn't push unrelated posts into the feed" do
    insert(:post) |> FeedChannel.notify("added")
    refute_push "post:added", %{post: _}
  end

  test "Pushes post update into the feed", %{user: user} do
    post = insert(:post, user: user, author: user)
    post |> FeedChannel.notify("edited")
    id = post.id
    assert_push "post:edited", %{post: %{id: ^id}}
  end

  test "Pushes post deletion into the feed", %{user: user} do
    post = insert(:post, user: user, author: user)
    post |> FeedChannel.notify("deleted")
    id = post.id
    assert_push "post:deleted", %{id: ^id}
  end
end
