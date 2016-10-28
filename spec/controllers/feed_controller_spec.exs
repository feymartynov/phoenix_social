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

    let! :expected_posts do
      [insert(:post, user: friend1, author: friend1, text: "1"),
       insert(:post, user: user, author: friend2, text: "2"),
       insert(:post, user: user, author: unrelated_user, text: "3"),
       insert(:post, user: user, author: friend3, text: "4"),
       insert(:post, user: user, author: user, text: "5"),
       insert(:post, user: friend2, author: user, text: "6")]
    end

    before do
      # these posts shouldn't appear in the feed
      insert(:post, user: friend1, author: friend2, text: "7")
      insert(:post, user: unrelated_user, author: unrelated_user, text: "8")
      time = Timex.now |> Timex.shift(days: -9)
      insert(:post, user: user, author: friend2, inserted_at: time, text: "9")
    end

    it "shows friends' posts" do
      assert {200, json} = api_call(:get, "/feed", as: user)
      texts = json["posts"] |> Enum.map(&(&1["text"]))
      expected_texts = expected_posts |> Enum.reverse |> Enum.map(&(&1.text))
      assert texts == expected_texts
    end
  end
end
