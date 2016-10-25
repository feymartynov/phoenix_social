defmodule PhoenixSocial.Integration.PresenceTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "Monitor friend's online presence" do
    user = insert(:user)
    friend = insert(:user, first_name: "Elvis", last_name: "Presley")
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/user#{user.id}"

      # should not see online friends box
      assert {:error, _} = search_element(:id, "sample_online_friends", 1)
    end

    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"
    end

    in_browser_session :user_session, fn ->
      # should now see the friend online
      online_friends = find_element(:id, "sample_online_friends")
      assert online_friends |> inner_text =~ "Elvis"
    end

    in_browser_session :friend_session, fn ->
      Hound.end_session
    end

    in_browser_session :user_session, fn ->
      # online friends box should now disappear
      assert {:error, _} = search_element(:id, "sample_online_friends", 1)
    end

    Hound.end_session
  end
end
