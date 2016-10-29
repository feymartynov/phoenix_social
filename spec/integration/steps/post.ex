defmodule PhoenixSocial.Integration.Steps.Post do
  use Hound.Helpers

  def find_post(id) do
    find_element(:css, "li[data-post-id='#{id}']")
  end

  def find_comment(id) do
    find_element(:css, "li[data-comment-id='#{id}']")
  end

  def find_comments_list(post_id) do
    find_post(post_id) |> find_within_element(:class, "comments-list")
  end

  def add_post(text) do
    form = find_element(:id, "create_post_form")

    form
    |> find_within_element(:css, "input[type=text]")
    |> click

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field(text)

    form
    |> find_within_element(:class, "btn-submit")
    |> click
  end

  def edit_post(id, new_text) do
    post = find_post(id)

    post
    |> find_within_element(:css, ".btn-edit")
    |> click

    form = post |> find_within_element(:class, "post-edit-form")

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field(new_text)

    form
    |> find_within_element(:class, "btn-submit")
    |> click
  end

  def delete_post(id) do
    find_post(id)
    |> find_within_element(:class, "btn-delete")
    |> click
  end

  def add_comment(post_id, text) do
    form = find_post(post_id) |> find_within_element(:class, "comment-form")

    form
    |> find_within_element(:css, "input[type=text]")
    |> click

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field(text)

    form
    |> find_within_element(:class, "btn-submit")
    |> click
  end

  def edit_comment(id, new_text) do
    comment = find_comment(id)

    # expand form
    comment
    |> find_within_element(:css, ".btn-edit")
    |> click

    form = comment |> find_within_element(:class, "post-edit-comment")

    form
    |> find_within_element(:css, "textarea[name=text]")
    |> fill_field(new_text)

    form
    |> find_within_element(:class, "btn-submit")
    |> click
  end

  def delete_comment(id) do
    find_comment(id)
    |> find_within_element(:class, "btn-delete")
    |> click
  end
end
