defmodule PhoenixSocial.Integration.Feed.CommentLiveUpdateSpec do
  use ESpec.Phoenix.Extend, :integration
  import PhoenixSocial.Integration.Steps.Post

  let! :user, do: insert(:user)
  let! :friend, do: insert(:user)
  let! :post, do: insert(:post, user: friend, author: friend)
  let! :comment, do: insert(:comment, post: post, author: friend, text: "hi!")

  before do
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/feed"
    end

    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"
    end
  end

  finally do
    Hound.end_session
  end

  it "adds a comment" do
    text = "hello world"

    in_browser_session :friend_session, fn ->
      add_comment(post.id, text)
      assert find_comments_list(post.id) |> inner_text =~ text
    end

    in_browser_session :user_session, fn ->
      assert find_comments_list(post.id) |> inner_text =~ text
    end
  end

  it "edits a comment" do
    new_text = "edited"

    in_browser_session :friend_session, fn ->
      edit_comment(comment.id, new_text)
      assert find_comments_list(post.id) |> inner_text =~ new_text
    end

    in_browser_session :user_session, fn ->
      assert find_comments_list(post.id) |> inner_text =~ new_text
    end
  end

  it "deletes a comment" do
    in_browser_session :user_session, fn ->
      assert find_comments_list(post.id) |> inner_text =~ comment.text
    end

    in_browser_session :friend_session, fn ->
      delete_comment(comment.id)
      refute find_element(:id, "wall") |> inner_text =~ comment.text
    end

    in_browser_session :user_session, fn ->
      refute find_element(:id, "feed") |> inner_text =~ comment.text
    end
  end
end
