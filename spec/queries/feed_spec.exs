defmodule PhoenixSocial.Queries.FeedSpec do
  use ESpec.Phoenix, model: Feed, async: true
  
  alias PhoenixSocial.Repo
  alias PhoenixSocial.Queries.Feed

  describe "#belongs_to_feed?" do
    let :user, do: insert(:user)
    let :friend, do: insert(:user)

    it "allows own post to the feed" do
      post = insert(:post, user: insert(:user), author: user)
      assert Feed.belongs_to_feed?(post, user)
    end

    it "allows a post from own wall to the feed" do
      post = insert(:post, user: user, author: insert(:user))
      assert Feed.belongs_to_feed?(post, user)
    end

    it "forbids unrelated post to the feed" do
      refute Feed.belongs_to_feed?(insert(:post), insert(:user))
    end

    context "with confirmed friend" do
      before do
        insert(:friendship, user1: user, user2: friend, state: "confirmed")
        insert(:friendship, user1: friend, user2: user, state: "confirmed")
      end

      it "allows a friend's post on his wall to the feed" do
        post = insert(:post, user: friend, author: friend)
        assert Feed.belongs_to_feed?(post, user |> Repo.preload(:friendships))
      end

      it "forbids a friend's post on someone else's wall to the feed" do
        post = insert(:post, user: insert(:user), author: friend)
        refute Feed.belongs_to_feed?(post, user |> Repo.preload(:friendships))
      end
    end

    context "with rejected friend" do
      before do
        insert(:friendship, user1: user, user2: friend, state: "reject")
        insert(:friendship, user1: friend, user2: user, state: "confirmed")
      end

      it "forbids a rejected friend's post on his wall to the feed" do
        post = insert(:post, user: friend, author: friend)
        refute Feed.belongs_to_feed?(post, user |> Repo.preload(:friendships))
      end
    end
  end
end
