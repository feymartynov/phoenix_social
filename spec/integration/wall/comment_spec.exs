defmodule PhoenixSocial.Integration.Wall.CommentSpec do
  use ESpec.Phoenix.Extend, :integration
  import PhoenixSocial.Integration.Steps.Post

  it "comments a post" do
    post = insert(:post)
    insert(:user) |> sign_in
    navigate_to "/user#{post.user.profile.id}"

    text = "hello world"
    add_comment(post.id, text)

    assert find_comments_list(post.id) |> inner_text =~ text
    refresh_page
    assert find_comments_list(post.id) |> inner_text =~ text
  end

  context "with a comment" do
    let! :comment, do: insert(:comment, text: "hello world")

    it "shows post comments" do
      comment.post.user |> sign_in
      navigate_to "/user#{comment.post.user.profile.id}"

      assert find_comments_list(comment.post_id) |> inner_text =~ comment.text
    end

    it "edits a comment" do
      comment.author |> sign_in
      navigate_to "/user#{comment.post.user.profile.id}"

      new_text = "edited"
      edit_comment(comment.id, new_text)

      assert find_comments_list(comment.post.id) |> inner_text =~ new_text
      refresh_page
      assert find_comments_list(comment.post.id) |> inner_text =~ new_text
    end

    it "deletes a comment" do
      comment.post.user |> sign_in
      navigate_to "/user#{comment.post.user.profile.id}"

      delete_comment(comment.id)

      refute find_element(:id, "wall") |> inner_text =~ comment.text
      refresh_page
      refute find_element(:id, "wall") |> inner_text =~ comment.text
    end
  end
end
