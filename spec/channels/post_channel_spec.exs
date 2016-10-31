defmodule PhoenixSocial.PostChannelSpec do
  use ESpec.Phoenix, channel: PostChannel

  alias PhoenixSocial.PostChannel

  let :user, do: insert(:user) |> Repo.preload([:profile, :friendships])
  let :user_socket, do: socket("users:#{user.id}", %{current_user: user})

  context "with feed" do
    let :post do
      insert(:post, user: user, author: user)
      |> Repo.preload([:comments, author: :profile])
    end

    let :comment do
      insert(:comment, post: post)
      |> Repo.preload(author: :profile)
    end

    before do
      user_socket |> subscribe_and_join(PostChannel, "feed")
    end
    
    it "pushes a new post into the feed" do
      post |> PostChannel.notify("post:added")
      id = post.id
      assert_push "post:added", %{post: %{id: ^id}}
    end

    it "doesn't push unrelated posts into the feed" do
      insert(:post) |> PostChannel.notify("post:added")
      refute_push "post:added", %{post: _}
    end

    it "pushes post update into the feed" do
      post |> PostChannel.notify("post:edited")
      id = post.id
      assert_push "post:edited", %{post: %{id: ^id}}
    end

    it "pushes post deletion into the feed" do
      post |> PostChannel.notify("post:deleted")
      id = post.id
      assert_push "post:deleted", %{post: %{id: ^id}}
    end

    it "pushes a new comment into the feed" do
      comment |> PostChannel.notify("comment:added")
      id = comment.id
      assert_push "comment:added", %{comment: %{id: ^id}}
    end

    it "doesn't push unrelated comments into the feed" do
      insert(:comment) |> PostChannel.notify("comment:added")
      refute_push "comment:added", %{comment: _}
    end

    it "pushes comment update into the feed" do
      comment |> PostChannel.notify("comment:edited")
      id = comment.id
      assert_push "comment:edited", %{comment: %{id: ^id}}
    end

    it "pushes comment deletion into the feed" do
      comment |> PostChannel.notify("comment:deleted")
      id = comment.id
      assert_push "comment:deleted", %{comment: %{id: ^id}}
    end
  end
  
  context "with wall" do
    let :user, do: insert(:user) |> Repo.preload(:profile)
    let :other_user, do: insert(:user) |> Repo.preload(:profile)

    let :post do
      insert(:post, user: user, author: other_user)
      |> Repo.preload([:comments, author: :profile])
    end

    let :comment do
      insert(:comment, post: post, author: other_user)
      |> Repo.preload(author: :profile)
    end

    before do
      socket |> subscribe_and_join(PostChannel, "wall:#{post.user_id}")
    end

    it "pushes a new post onto the wall" do
      post |> PostChannel.notify("post:added")
      id = post.id
      assert_push "post:added", %{post: %{id: ^id}}
    end
  
    it "pushes post update onto the wall" do
      post |> PostChannel.notify("post:edited")
      id = post.id
      assert_push "post:edited", %{post: %{id: ^id}}
    end
  
    it "pushes post deletion onto the wall" do
      post |> PostChannel.notify("post:deleted")
      id = post.id
      assert_push "post:deleted", %{post: %{id: ^id}}
    end
  
    it "pushes a new comment onto the wall" do
      comment |> PostChannel.notify("comment:added")
      id = comment.id
      assert_push "comment:added", %{comment: %{id: ^id}}
    end
  
    it "pushes comment update onto the wall" do
      comment |> PostChannel.notify("comment:edited")
      id = comment.id
      assert_push "comment:edited", %{comment: %{id: ^id}}
    end
  
    it "pushes comment deletion onto the wall" do
      comment |> PostChannel.notify("comment:deleted")
      id = comment.id
      assert_push "comment:deleted", %{comment: %{id: ^id}}
    end    
  end
end
