defmodule PhoenixSocial.Integration.Wall.PostLiveUpdateSpec do
  use ESpec.Phoenix.Extend, :integration
  import PhoenixSocial.Integration.Steps.Post

  let! :user, do: insert(:user)
  let! :friend, do: insert(:user)
  let! :post, do: insert(:post, author: friend, user: friend)

  before do
    insert(:friendship, user1: user, user2: friend, state: "confirmed")
    insert(:friendship, user1: friend, user2: user, state: "confirmed")

    in_browser_session :user_session, fn ->
      user |> sign_in
      navigate_to "/user#{friend.id}"
    end

    in_browser_session :friend_session, fn ->
      friend |> sign_in
      navigate_to "/user#{friend.id}"
    end
  end

  finally do
    Hound.end_session
  end

  it "adds a post" do
    text = "hello world"

    in_browser_session :friend_session, fn ->
      add_post(text)
      assert find_element(:id, "wall") |> inner_text =~ text
    end

    in_browser_session :user_session, fn ->
      assert find_element(:id, "wall") |> inner_text =~ text
    end
  end

  it "edits a post" do
    new_text = "edited"

    in_browser_session :friend_session, fn ->
      edit_post(post.id, new_text)
      assert find_post(post.id) |> inner_text =~ new_text
    end

    in_browser_session :user_session, fn ->
      assert find_post(post.id) |> inner_text =~ new_text
    end
  end

  it "deletes a post" do
    in_browser_session :friend_session, fn ->
      delete_post(post.id)
      refute find_element(:id, "wall") |> inner_text =~ post.text
    end

    in_browser_session :user_session, fn ->
      refute find_element(:id, "wall") |> inner_text =~ post.text
    end
  end
end
