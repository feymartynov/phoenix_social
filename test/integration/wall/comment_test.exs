defmodule PhoenixSocial.Integration.Wall.CommentTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "See post comments" do
    comment = insert(:comment, text: "hello world")
    comment.post.user |> sign_in
    navigate_to "/user#{comment.post.user_id}"

    comments_list = find_element(:class, "comments-list")
    assert comments_list |> inner_text =~ "hello world"
  end

  @tag :integration
  test "Comment a post" do
    post = insert(:post)
    insert(:user, first_name: "John", last_name: "Lennon") |> sign_in

    navigate_to "/user#{post.user_id}"
    form = find_element(:class, "comment-form")

    # expand comment form
    form
    |> find_within_element(:css, "input[type=text]")
    |> click

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field("hello world")

    form
    |> find_within_element(:class, "btn-submit")
    |> click

    comments_list = find_element(:class, "comments-list")
    assert comments_list |> inner_text =~ "hello world"

    refresh_page
    comments_list = find_element(:class, "comments-list")
    assert comments_list |> inner_text =~ "hello world"
  end

  @tag :integration
  test "Edit a comment" do
    comment = insert(:comment)
    comment.author |> sign_in
    navigate_to "/user#{comment.post.user_id}"

    find_element(:css, ".comments-list .btn-edit") |> click

    form = find_element(:class, "post-edit-comment")

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field("Edited")

    form
    |> find_within_element(:class, "btn-submit")
    |> click

    assert find_element(:id, "wall") |> inner_text =~ "Edited"

    refresh_page
    assert find_element(:id, "wall") |> inner_text =~ "Edited"
  end

  @tag :integration
  test "Delete a comment" do
    comment = insert(:comment, text: "hello world")
    comment.post.user |> sign_in
    navigate_to "/user#{comment.post.user_id}"

    find_element(:css, ".comments-list .btn-delete") |> click
    refute find_element(:id, "wall") |> inner_text =~ "hello world"

    refresh_page
    refute find_element(:id, "wall") |> inner_text =~ "hello world"
  end
end
