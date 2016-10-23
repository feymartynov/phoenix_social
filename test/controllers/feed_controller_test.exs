defmodule PhoenixSocial.FeedControllerTest do
  use PhoenixSocial.ConnCase

  test "Show friends' posts" do
    user = insert(:user)
    
    friend1 = insert(:user)
    insert(:friendship, user1: user, user2: friend1, state: "confirmed")    

    friend2 = insert(:user)
    insert(:friendship, user1: user, user2: friend2, state: "confirmed")

    friend3 = insert(:user)
    insert(:friendship, user1: user, user2: friend3, state: "rejected")

    unrelated_user = insert(:user)

    post1 = insert(:post, user: friend1, author: friend1, text: "1")
    post2 = insert(:post, user: user, author: friend2, text: "2")
    post3 = insert(:post, user: user, author: unrelated_user, text: "3")
    post4 = insert(:post, user: user, author: friend3, text: "4")
    post5 = insert(:post, user: user, author: user, text: "5")
    post6 = insert(:post, user: friend1, author: user, text: "6")

    # these posts shouldn't appear in the feed
    insert(:post, user: friend1, author: friend2, text: "7")
    insert(:post, user: unrelated_user, author: unrelated_user, text: "8")
    long_ago = Timex.now |> Timex.shift(days: -9)
    insert(:post, user: user, author: friend1, text: "9", inserted_at: long_ago)

    assert {200, json} = api_call(:get, "/feed", as: user)
    posts = json["posts"] |> Enum.map(&(&1["text"]))
    expected_posts = [post6, post5, post4, post3, post2, post1] |> Enum.map(&(&1.text))
    assert posts == expected_posts
  end
end
