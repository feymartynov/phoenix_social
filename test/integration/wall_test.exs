defmodule PhoenixSocial.Integration.WallTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "See user's wall" do
    user = insert(:user) |> sign_in
    posts = insert_list(3, :post, user: user)

    navigate_to "/user#{user.id}"
    wall = find_element(:id, "wall")

    for post <- posts do
      assert wall |> inner_text =~ post.text
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
end
