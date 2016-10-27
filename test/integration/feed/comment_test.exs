defmodule PhoenixSocial.Integration.Feed.CommentTest do
  use PhoenixSocial.IntegrationCase

  setup do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    %{user: user, friend: friend}
  end

  @tag :integration
  test "See comments in the feed", %{user: user, friend: friend} do
    post = insert(:post, author: friend, user: friend)
    author = insert(:user, first_name: "John", last_name: "Lennon")
    insert(:comment, post: post, author: author, text: "hello world")

    user |> sign_in
    navigate_to "/feed"

    comments_list = find_element(:css, "#feed .comments-list")
    assert comments_list |> inner_text =~ "John Lennon"
    assert comments_list |> inner_text =~ "hello world"
  end

  @tag :integration
  test "Comment a post in the feed", %{user: user, friend: friend} do
    insert(:post, author: friend, user: friend)

    user |> sign_in
    navigate_to "/feed"

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

    comments_list = find_element(:css, "#feed .comments-list")
    assert comments_list |> inner_text =~ "hello world"
  end

  @tag :integration
  test "Edit a comment in the feed", %{user: user, friend: friend} do
    post = insert(:post, author: friend, user: friend)
    insert(:comment, author: user, post: post, text: "hello world")

    user |> sign_in
    navigate_to "/feed"
    find_element(:css, ".comments-list .btn-edit") |> click

    form = find_element(:class, "post-edit-comment")

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field("Edited")

    form
    |> find_within_element(:class, "btn-submit")
    |> click

    assert find_element(:id, "feed") |> inner_text =~ "Edited"

    refresh_page
    assert find_element(:id, "feed") |> inner_text =~ "Edited"
  end

  @tag :integration
  test "Delete a comment in the feed", %{user: user, friend: friend} do
    post = insert(:post, author: friend, user: friend)
    insert(:comment, author: user, post: post, text: "hello world")

    user |> sign_in
    navigate_to "/feed"

    find_element(:css, ".comments-list .btn-delete") |> click
    refute find_element(:id, "feed") |> inner_text =~ "hello world"

    refresh_page
    refute find_element(:id, "feed") |> inner_text =~ "hello world"
  end
end
