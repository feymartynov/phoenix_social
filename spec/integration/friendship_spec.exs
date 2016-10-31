defmodule PhoenixSocial.Integration.FriendshipSpec do
  use ESpec.Phoenix.Extend, :integration

  let! :user, do: insert(:user) |> sign_in
  
  let! :friend do
    insert(
      :user,
      profile: build(:profile, first_name: "Elvis", last_name: "Presley"))
  end

  it "adds a user to friends" do
    # visit user page and add a him to friends
    navigate_to "/user#{friend.profile.id}"
    find_element(:class, "btn-add-friend") |> click

    # see the remove button
    assert find_element(:class, "btn-remove-friend")

    # see the friend in the list
    find_element(:id, "user_menu_friends_link") |> click
    assert visible_page_text =~ "Elvis Presley"
  end

  it "removes a user from friends" do
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    # visit friend's page and remove him from friends
    navigate_to "/user#{friend.profile.id}"
    find_element(:class, "btn-remove-friend") |> click

    # see the add button
    assert find_element(:class, "btn-add-friend")

    # see the friend absent in the list
    find_element(:id, "user_menu_friends_link") |> click
    refute visible_page_text =~ "Elvis Presley"
  end

  it "confirms friendship" do
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
    insert(:friendship, user1: user, user2: friend, state: "pending")

    # see the friend in the pending friends list
    navigate_to "/user#{user.profile.id}/friends"
    assert find_element(:css, "#friends_lists_tabs .active #friends_tab_pending")
    assert visible_page_text =~ "Elvis Presley"

    # confirm friendship
    find_element(:class, "btn-add-friend") |> click
    :timer.sleep(500)

    # see confirmed friends tab active
    assert find_element(:css, "#friends_lists_tabs .active #friends_tab_confirmed")

    # see the friend in the list
    assert visible_page_text =~ "Elvis Presley"

    # see the remove button
    assert find_element(:class, "btn-remove-friend")
  end
end
