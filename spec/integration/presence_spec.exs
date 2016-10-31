defmodule PhoenixSocial.Integration.PresenceSpec do
  use ESpec.Phoenix.Extend, :integration

  let :user, do: insert(:user)

  let :friend do
    insert(
      :user,
      profile: build(:profile, first_name: "Elvis", last_name: "Presley"))
  end

  before do
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")
  end

  it "monitors friend's online presence" do
    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/user#{user.profile.id}"

      # should not see online friends box
      assert {:error, _} = search_element(:id, "sample_online_friends", 1)
    end

    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.profile.id}"
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
