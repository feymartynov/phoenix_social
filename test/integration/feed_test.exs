defmodule PhoenixSocial.Integration.FeedTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "See newsfeed" do
    user = insert(:user) |> sign_in
    posts = insert_list(30, :post, user: user, author: user)

    navigate_to "/feed"
    feed = find_element(:id, "feed")

    # should see only 20 posts
    lis = feed |> find_all_within_element(:css, "li[data-post-id]")
    assert lis |> length == 20

    # scroll to the bottom of the page
    execute_script("window.scrollTo(0, document.body.scrollHeight);")
    :timer.sleep(1500) # FIXME: doesn't wait for update

    # older posts should now appear
    lis = feed |> find_all_within_element(:css, "li[data-post-id]")
    assert lis |> length == 30

    # there should be all posts' texts
    for post <- posts do
      selector = "li[data-post-id='#{post.id}']"
      post_li = feed |> find_within_element(:css, selector)
      assert post_li |> inner_text =~ post.text
    end
  end
end
