defmodule PhoenixSocial.Integration.WallTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "See user's wall" do
    user = insert(:user) |> sign_in
    posts = insert_list(15, :post, user: user)

    navigate_to "/user#{user.id}"
    wall = find_element(:id, "wall")

    # should see only 10 posts
    lis = wall |> find_all_within_element(:css, "li[data-post-id]")
    assert lis |> length == 10

    # scroll to the bottom of the page
    execute_script("window.scrollTo(0, document.body.scrollHeight);")

    # older posts should now appear
    lis = wall |> find_all_within_element(:css, "li[data-post-id]")
    assert lis |> length == 15

    # there should be all posts' texts
    for post <- posts do
      selector = "li[data-post-id='#{post.id}']"
      post_li = wall |> find_within_element(:css, selector)
      assert post_li |> inner_text =~ post.text
    end
  end

  @tag :integration
  test "Make a post on own wall" do
    user = insert(:user) |> sign_in

    navigate_to "/user#{user.id}"
    wall = find_element(:id, "wall")

    # expand post form
    wall
    |> find_within_element(:css, "input[type=text]")
    |> click

    wall
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field("hello world")

    wall
    |> find_within_element(:class, "btn-send-post")
    |> click

    posts_list = wall |> find_within_element(:css, "ul")
    assert posts_list |> inner_text =~ "hello world"
  end

  @tag :integration
  test "Editing a post" do
    post = insert(:post, text: "Edit me")
    post.user |> sign_in

    navigate_to "/user#{post.user.id}"
    post_li = find_element(:css, "#wall li[data-post-id='#{post.id}']")

    assert post_li |> inner_text =~ "Edit me"

    post_li
    |> find_within_element(:class, "btn-edit-post")
    |> click

    edit_form = post_li |> find_within_element(:class, "post-edit-form")

    edit_form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field("Edited")

    edit_form
    |> find_within_element(:class, "btn-send-post")
    |> click

    assert {:error, _} = post_li |> search_within_element(:class, "post-edit-form", 0)
    assert post_li |> inner_text =~ "Edited"

    refresh_page
    assert find_element(:id, "wall") |> inner_text =~ "Edited"
  end

  @tag :integration
  test "Deleting a post" do
    post = insert(:post, text: "Delete me")
    post.user |> sign_in

    navigate_to "/user#{post.user.id}"
    post_li = find_element(:css, "#wall li[data-post-id='#{post.id}']")

    assert post_li |> inner_text =~ "Delete me"

    post_li
    |> find_within_element(:class, "btn-delete-post")
    |> click

    assert !(find_element(:id, "wall") |> inner_text =~ "Delete me")
    assert {:error, _} = search_element(:css, "#wall li[data-post-id='#{post.id}']", 0)

    refresh_page
    assert !(find_element(:id, "wall") |> inner_text =~ "Delete me")
  end
end
