defmodule PhoenixSocial.Integration.Wall.CommentLiveUpdateSpec do
  use ESpec.Phoenix.Extend, :integration
  import PhoenixSocial.Integration.Steps.Post

  let! :user, do: insert(:user)
  let! :friend, do: insert(:user)

  let! :post do
    insert(:post, profile: friend.profile, author: friend.profile)
  end

  let! :comment do
    insert(:comment, post: post, author: friend.profile, text: "hi!")
  end

  before do
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/user#{friend.profile.id}"
    end

    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.profile.id}"
    end
  end

  finally do
    Hound.end_session
  end

  it "adds a comment" do
    text = "hello world"

    in_browser_session :friend_session, fn ->
      add_comment(post.id, text)
      :timer.sleep(1500)
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
      :timer.sleep(1500)
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
      :timer.sleep(1000)
      refute find_element(:id, "wall") |> inner_text =~ comment.text
    end

    in_browser_session :user_session, fn ->
      refute find_element(:id, "wall") |> inner_text =~ comment.text
    end
  end
end
