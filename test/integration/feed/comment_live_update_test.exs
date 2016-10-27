defmodule PhoenixSocial.Integration.Feed.CommentLiveUpdateTest do
  use PhoenixSocial.IntegrationCase

  setup do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    post = insert(:post, user: friend, author: friend)
    %{user: user, friend: friend, post: post}
  end

  @tag :integration
  test "Add a comment", %{user: user, friend: friend} do
    # the user signs in, goes to the feed and waits for updates
    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/feed"
    end

    # in parallel session the friend goes to his profile and makes a comment
    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"

      form = find_element(:class, "comment-form")

      # expand comment form
      form
      |> find_within_element(:css, "input[type=text]")
      |> click

      form
      |> find_within_element(:css, "textarea[name=text]")
      |> fill_field("hello world")

      form
      |> find_within_element(:class, "btn-submit")
      |> click

      comments_list = find_element(:class, "comments-list")
      assert comments_list |> inner_text =~ "hello world"
    end

    # the user should see the friend's comment in the feed without page refresh
    in_browser_session :user_session, fn ->
      post_li = find_element(:css, "#feed li[data-post-id]")
      assert post_li |> inner_text =~ "hello world"
    end

    Hound.end_session
  end

  @tag :integration
  test "Edit a comment", context do
    insert(:comment, post: context.post, author: context.friend)

    # the user signs in, goes to the feed and waits for updates
    in_browser_session :user_session, fn ->
      context.user |> sign_in
      navigate_to "/feed"
    end

    # in parallel session the friend goes to his profile and makes a comment
    in_browser_session :friend_session, fn ->
      context.friend |> sign_in
      navigate_to "/user#{context.friend.id}"
      find_element(:css, ".comments-list .btn-edit") |> click

      form = find_element(:class, "post-edit-comment")

      form
      |> find_within_element(:css, "textarea[name=text]")
      |> fill_field("Edited")

      form
      |> find_within_element(:class, "btn-submit")
      |> click

      comments_list = find_element(:class, "comments-list")
      assert comments_list |> inner_text =~ "Edited"
    end

    # the user should see the friend's comment in the feed without page refresh
    in_browser_session :user_session, fn ->
      post_li = find_element(:css, "#feed li[data-post-id]")
      assert post_li |> inner_text =~ "Edited"
    end

    Hound.end_session
  end

  @tag :integration
  test "Delete a comment", context do
    insert(:comment, post: context.post, author: context.friend, text: "hello")

    # the user signs in, goes to the feed and waits for updates
    in_browser_session :user_session, fn ->
      context.user |> sign_in
      navigate_to "/feed"

      post_li = find_element(:css, "#feed li[data-post-id]")
      assert post_li |> inner_text =~ "hello"
    end

    # in parallel session the friend goes to his profile and makes a comment
    in_browser_session :friend_session, fn ->
      context.friend |> sign_in
      navigate_to "/user#{context.friend.id}"
      find_element(:css, ".comments-list .btn-delete") |> click

      refute find_element(:id, "wall") |> inner_text =~ "hello"
    end

    # the user should see the friend's comment in the feed without page refresh
    in_browser_session :user_session, fn ->
      post_li = find_element(:css, "#feed li[data-post-id]")
      refute post_li |> inner_text =~ "hello"
    end

    Hound.end_session
  end
end
