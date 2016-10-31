defmodule PhoenixSocial.Integration.Feed.CommentSpec do
  use ESpec.Phoenix.Extend, :integration
  import PhoenixSocial.Integration.Steps.Post

  let! :user, do: insert(:user)
  let! :friend, do: insert(:user)

  let! :post do
    insert(:post, author: friend.profile, profile: friend.profile)
  end

  let! :comment do
    insert(:comment, author: user.profile, post: post, text: "hi!")
  end

  before do
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    user |> sign_in
    navigate_to "/feed"
  end

  it "shows comments in the feed" do
    assert find_comments_list(post.id) |> inner_text =~ comment.text
  end

  it "comments the post in the feed" do
    text = "hello world"
    add_comment(post.id, text)
    :timer.sleep(1500) # FIXME: doesn't wait for update

    assert find_comments_list(post.id) |> inner_text =~ text
  end

  it "edits a comment in the feed" do
    new_text = "edited"
    edit_comment(comment.id, new_text)
    :timer.sleep(1500) # FIXME: doesn't wait for update

    assert find_comment(comment.id) |> inner_text =~ new_text
    refresh_page
    assert find_comment(comment.id) |> inner_text =~ new_text
  end

  it "deletes a comment in the feed" do
    delete_comment(comment.id)
    :timer.sleep(1000) # FIXME: doesn't wait for update

    refute find_element(:id, "feed") |> inner_text =~ comment.text
    refresh_page
    refute find_element(:id, "feed") |> inner_text =~ comment.text
  end
end
