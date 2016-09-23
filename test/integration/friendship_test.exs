defmodule PhoenixSocial.Integration.FriendshipTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "Add a user to friends" do
    insert(:user) |> sign_in
    friend = insert(:user, first_name: "Elvis", last_name: "Presley")

    # visit user page and add him to friends
    navigate_to "/user#{friend.id}"
    find_element(:class, "btn-add-friend") |> click

    # see the remove button
    assert find_element(:class, "btn-remove-friend")

    # see the friend in the list
    find_element(:id, "user_menu_friends_link") |> click
    assert visible_page_text =~ "#{friend.first_name} #{friend.last_name}"
  end

  @tag :integration
  test "Remove a user from friends" do
    user = insert(:user) |> sign_in
    friend = insert(:user, first_name: "Elvis", last_name: "Presley")
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    # visit friend's page and remove him from friends
    navigate_to "/user#{friend.id}"
    find_element(:class, "btn-remove-friend") |> click

    # see the add button
    assert find_element(:class, "btn-add-friend")

    # see the friend absent in the list
    find_element(:id, "user_menu_friends_link") |> click
    assert !(visible_page_text =~ "#{friend.first_name} #{friend.last_name}")
  end

  @tag :integration
  test "Confirm friendship" do
    user = insert(:user) |> sign_in
    friend = insert(:user, first_name: "Elvis", last_name: "Presley")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    insert(:friendship, user1: user, user2: friend, state: "pending")
    friend_name = "#{friend.first_name} #{friend.last_name}"

    # see the friend in the pending friends list
    navigate_to "/user#{user.id}/friends"
    assert find_element(:css, "#friends_lists_tabs .active #friends_tab_pending")
    assert visible_page_text =~ friend_name

    # confirm friendship
    find_element(:class, "btn-add-friend") |> click

    # see confirmed friends tab active
    assert find_element(:css, "#friends_lists_tabs .active #friends_tab_confirmed")

    # see the friend in the list
    assert visible_page_text =~ friend_name

    # see the remove button
    assert find_element(:class, "btn-remove-friend")
  end
end
