defmodule PhoenixSocial.PostChannelTest do
  use PhoenixSocial.ChannelCase

  alias PhoenixSocial.PostChannel

  setup do
    user = insert(:user)
    socket = socket("users:#{user.id}", %{current_user: user})
    {:ok, user: user, socket: socket}
  end

  test "Pushes a new post into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    post = insert(:post, user: context.user, author: context.user)
    post |> PostChannel.notify("post:added")

    id = post.id
    assert_push "post:added", %{post: %{id: ^id}}
  end

  test "Doesn't push unrelated posts into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    insert(:post) |> PostChannel.notify("post:added")
    refute_push "post:added", %{post: _}
  end

  test "Pushes post update into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    post = insert(:post, user: context.user, author: context.user)
    post |> PostChannel.notify("post:edited")

    id = post.id
    assert_push "post:edited", %{post: %{id: ^id}}
  end

  test "Pushes post deletion into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    post = insert(:post, user: context.user, author: context.user)
    post |> PostChannel.notify("post:deleted")

    id = post.id
    assert_push "post:deleted", %{post: %{id: ^id}}
  end

  test "Pushes a new comment into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    post = insert(:post, user: context.user)
    comment = insert(:comment, post: post)
    comment |> PostChannel.notify("comment:added")

    id = comment.id
    assert_push "comment:added", %{comment: %{id: ^id}}
  end

  test "Doesn't push unrelated comments into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")
    insert(:comment) |> PostChannel.notify("comment:added")
    refute_push "comment:added", %{comment: _}
  end

  test "Pushes comment update into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    post = insert(:post, user: context.user)
    comment = insert(:comment, post: post)
    comment |> PostChannel.notify("comment:edited")

    id = comment.id
    assert_push "comment:edited", %{comment: %{id: ^id}}
  end

  test "Pushes comment deletion into the feed", context do
    context.socket |> subscribe_and_join(PostChannel, "feed")

    post = insert(:post, user: context.user)
    comment = insert(:comment, post: post)
    comment |> PostChannel.notify("comment:deleted")

    id = comment.id
    assert_push "comment:deleted", %{comment: %{id: ^id}}
  end

  test "Pushes a new post onto the wall", context do
    wall_user = insert(:user)
    context.socket |> subscribe_and_join(PostChannel, "wall:#{wall_user.id}")

    post = insert(:post, user: wall_user)
    post |> PostChannel.notify("post:added")

    id = post.id
    assert_push "post:added", %{post: %{id: ^id}}
  end

  test "Pushes post update onto the wall", context do
    wall_user = insert(:user)
    context.socket |> subscribe_and_join(PostChannel, "wall:#{wall_user.id}")

    post = insert(:post, user: wall_user)
    post |> PostChannel.notify("post:edited")

    id = post.id
    assert_push "post:edited", %{post: %{id: ^id}}
  end

  test "Pushes post deletion onto the wall", context do
    wall_user = insert(:user)
    context.socket |> subscribe_and_join(PostChannel, "wall:#{wall_user.id}")

    post = insert(:post, user: wall_user)
    post |> PostChannel.notify("post:deleted")

    id = post.id
    assert_push "post:deleted", %{post: %{id: ^id}}
  end

  test "Pushes a new comment onto the wall", context do
    wall_user = insert(:user)
    context.socket |> subscribe_and_join(PostChannel, "wall:#{wall_user.id}")

    post = insert(:post, user: wall_user)
    comment = insert(:comment, post: post)
    comment |> PostChannel.notify("comment:added")

    id = comment.id
    assert_push "comment:added", %{comment: %{id: ^id}}
  end

  test "Pushes comment update onto the wall", context do
    wall_user = insert(:user)
    context.socket |> subscribe_and_join(PostChannel, "wall:#{wall_user.id}")

    post = insert(:post, user: wall_user)
    comment = insert(:comment, post: post)
    comment |> PostChannel.notify("comment:edited")

    id = comment.id
    assert_push "comment:edited", %{comment: %{id: ^id}}
  end

  test "Pushes comment deletion onto the wall", context do
    wall_user = insert(:user)
    context.socket |> subscribe_and_join(PostChannel, "wall:#{wall_user.id}")

    post = insert(:post, user: wall_user)
    comment = insert(:comment, post: post)
    comment |> PostChannel.notify("comment:deleted")

    id = comment.id
    assert_push "comment:deleted", %{comment: %{id: ^id}}
  end
end
