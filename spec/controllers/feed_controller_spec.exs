defmodule PhoenixSocial.FeedControllerSpec do
  use ESpec.Phoenix, controller: FeedController

  describe "#show" do
    let :user, do: insert(:user)
    let :unrelated_user, do: insert(:user)

    let :friend1 do
      friend = insert(:user)
      insert(:friendship, user1: user, user2: friend, state: "confirmed")
      insert(:friendship, user1: friend, user2: user, state: "confirmed")
      friend
    end

    let :friend2 do
      friend = insert(:user)
      insert(:friendship, user1: user, user2: friend, state: "confirmed")
      insert(:friendship, user1: friend, user2: user, state: "confirmed")
      friend
    end

    let :friend3 do
      friend = insert(:user)
      insert(:friendship, user1: user, user2: friend, state: "rejected")
      insert(:friendship, user1: friend, user2: user, state: "confirmed")
      friend
    end

    let! :expected_posts, do: [
      insert(
        :post,
        profile: friend1.profile,
        author: friend1.profile,
        text: "1"),
      insert(
        :post,
        profile: user.profile,
        author: friend2.profile,
        text: "2"),
      insert(
       :post,
       profile: user.profile,
       author: unrelated_user.profile,
       text: "3"),
      insert(
       :post,
       profile: user.profile,
       author: friend3.profile,
       text: "4"),
      insert(
       :post,
       profile: user.profile,
       author: user.profile,
       text: "5"),
      insert(
       :post,
       profile: friend2.profile,
       author: user.profile,
       text: "6")]

    before do
      # these posts shouldn't appear in the feed
      insert(
        :post,
        profile: friend1.profile,
        author: friend2.profile,
        text: "7")

      insert(
        :post,
        profile: unrelated_user.profile,
        author: unrelated_user.profile,
        text: "8")

      insert(
        :post,
        profile: user.profile,
        author: friend2.profile,
        inserted_at: Timex.now |> Timex.shift(days: -9),
        text: "9")
    end

    it "shows friends' posts" do
      assert {200, json} = api_call(:get, "/feed", as: user)
      texts = json["posts"] |> Enum.map(&(&1["text"]))
      expected_texts = expected_posts |> Enum.reverse |> Enum.map(&(&1.text))
      assert texts == expected_texts
    end
  end
end
