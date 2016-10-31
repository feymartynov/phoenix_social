defmodule PhoenixSocial.Integration.Wall.PostSpec do
  use ESpec.Phoenix.Extend, :integration
  import PhoenixSocial.Integration.Steps.Post

  let :user do
    insert(
      :user,
      profile: build(:profile, first_name: "John", last_name: "Lennon"))
  end

  before do
    user |> sign_in
  end

  it "shows user's wall" do
    posts = insert_list(15, :post, profile: user.profile, author: user.profile)

    navigate_to "/user#{user.profile.id}"
    wall = find_element(:id, "wall")

    # should see only 10 posts
    lis = wall |> find_all_within_element(:css, "li[data-post-id]")
    assert lis |> length == 10

    # scroll to the bottom of the page
    execute_script("window.scrollTo(0, document.body.scrollHeight);")
    :timer.sleep(1500) # FIXME: doesn't wait for update

    # older posts should now appear
    lis = wall |> find_all_within_element(:css, "li[data-post-id]")
    assert lis |> length == 15

    # there should be all posts' texts
    for post <- posts do
      assert find_post(post.id) |> inner_text =~ post.text
    end
  end

  it "makes a post on own wall" do
    navigate_to "/user#{user.profile.id}"
    add_post("hello world")

    :timer.sleep(1500) # FIXME: doesn't wait for update
    assert find_element(:id, "wall") |> inner_text =~ "hello world"
  end

  it "makes a post on a friend's wall" do
    friend =
      insert(
        :user,
        profile: build(:profile, first_name: "Elvis", last_name: "Presley"))

    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    navigate_to "/user#{friend.profile.id}"
    add_post("hello world")

    :timer.sleep(1500) # FIXME: doesn't wait for update
    wall = find_element(:id, "wall")
    assert wall |> inner_text =~ "John Lennon"
    assert wall |> inner_text =~ "hello world"
  end

  it "shows someone's wall" do
    other_user = insert(:user)

    author_user =
      insert(
        :user,
        profile: build(:profile, first_name: "Ringo", last_name: "Starr"))

    insert(
      :post,
      profile: other_user.profile,
      author: author_user.profile,
      text: "hello world")

    navigate_to "/user#{other_user.profile.id}"
    wall = find_element(:id, "wall")

    # should not see the post form
    assert(
      {:error, _} =
        wall |> search_within_element(:id, "create_post_form", 1))

    assert wall |> inner_text =~ "Ringo Starr"
    assert wall |> inner_text =~ "hello world"
  end

  context "with own post" do
    let! :post do
      insert(:post, text: "hello", profile: user.profile, author: user.profile)
    end

    before do
      navigate_to "/user#{post.profile.id}"
    end

    it "edits the post" do
      new_text = "edited"
      edit_post(post.id, new_text)
      :timer.sleep(1500) # FIXME: doesn't wait for update

      assert find_post(post.id) |> inner_text =~ new_text
      refresh_page
      assert find_post(post.id) |> inner_text =~ new_text
    end

    it "deletes the post" do
      delete_post(post.id)
      :timer.sleep(1000) # FIXME: doesn't wait for update

      refute find_element(:id, "wall") |> inner_text =~ post.text
      refresh_page
      refute find_element(:id, "wall") |> inner_text =~ post.text
    end
  end
end
