defmodule PhoenixSocial.Integration.Feed.PostLiveUpdateTest do
  use PhoenixSocial.IntegrationCase

  setup do
    user = insert(:user)
    friend = insert(:user)
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    %{user: user, friend: friend}
  end

  @tag :integration
  test "Add a post", %{user: user, friend: friend} do
    # the user signs in, goes to the feed and waits for updates
    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/feed"
    end

    # in parallel session the friend goes to his profile and makes a post
    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"

      wall = find_element(:id, "create_post_form")

      # expand post form
      wall
      |> find_within_element(:css, "input[type=text]")
      |> click

      wall
      |> find_within_element(:css, "textarea[name=text]")
      |> fill_field("hello world")

      wall
      |> find_within_element(:class, "btn-submit")
      |> click

      posts_list = find_element(:css, "#wall ul")
      assert posts_list |> inner_text =~ "hello world"
    end

    # the user should see the friend's post in the feed without page refresh
    in_browser_session :user_session, fn ->
      post_li = find_element(:css, "#feed li[data-post-id]")
      assert post_li |> inner_text =~ "hello world"
    end

    Hound.end_session
  end

  @tag :integration
  test "Edit a post", %{user: user, friend: friend} do
    insert(:post, author: friend, user: friend)

    # the user signs in, goes to the feed and waits for updates
    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/feed"
    end

    # the friend signs in and edits the post
    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"

      post_li = find_element(:css, "#wall li[data-post-id]")

      post_li
      |> find_within_element(:class, "btn-edit")
      |> click

      edit_form = post_li |> find_within_element(:class, "post-edit-form")

      edit_form
      |> find_within_element(:css, "textarea[name=text]")
      |> fill_field("Edited")

      edit_form
      |> find_within_element(:class, "btn-submit")
      |> click

      assert {:error, _} = post_li |> search_within_element(:class, "post-edit-form", 0)
      assert post_li |> inner_text =~ "Edited"
    end

    # the user should see the update
    in_browser_session :user_session, fn ->
      post_li = find_element(:css, "#feed li[data-post-id]")
      assert post_li |> inner_text =~ "Edited"
    end

    Hound.end_session
  end

  @tag :integration
  test "Delete a post", %{user: user, friend: friend} do
    insert(:post, author: friend, user: friend)

    # the user signs in, goes to the feed and waits for updates
    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/feed"
    end

    # the friend signs in and deletes the post
    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"

      find_element(:css, "#wall li[data-post-id] .btn-delete") |> click
      refute find_element(:id, "wall") |> inner_text =~ "Edited"
    end

    # the post should disappear from user's feed
    in_browser_session :user_session, fn ->
      assert {:error, _} = search_element(:css, "#feed li[data-post-id]", 1)
    end

    Hound.end_session
  end
end