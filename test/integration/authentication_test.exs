defmodule PhoenixSocial.SessionTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "Sign in" do
    navigate_to "/sign_in"

    user = insert(:user)
    sign_in_form = find_element(:id, "sign_in_form")

    sign_in_form
    |> find_within_element(:name, "email")
    |> fill_field(user.email)

    sign_in_form
    |> find_within_element(:name, "password")
    |> fill_field("12345")

    sign_in_form
    |> find_within_element(:id, "sign_in_button")
    |> click

    assert find_element(:id, "sign_out_link")
    assert page_source =~ "#{user.first_name} #{user.last_name}"
  end

  @tag :integration
  test "Sign out" do
    insert(:user) |> sign_in

    navigate_to "/"
    find_element(:class, "navbar-toggle") |> click
    :timer.sleep(100)
    find_element(:id, "user_menu") |> click
    :timer.sleep(100)
    find_element(:id, "sign_out_link") |> click

    assert find_element(:id, "sign_in_button")
  end

  @tag :integration
  test "Sign up" do
    navigate_to "/sign_up"

    user = build(:user)
    sign_in_form = find_element(:id, "sign_up_form")

    sign_in_form
    |> find_within_element(:name, "first_name")
    |> fill_field(user.first_name)

    sign_in_form
    |> find_within_element(:name, "last_name")
    |> fill_field(user.last_name)

    sign_in_form
    |> find_within_element(:name, "email")
    |> fill_field(user.email)

    sign_in_form
    |> find_within_element(:name, "password")
    |> fill_field("12345")

    sign_in_form
    |> find_within_element(:name, "password_confirmation")
    |> fill_field("12345")

    sign_in_form
    |> find_within_element(:id, "sign_up_button")
    |> click

    assert find_element(:id, "sign_out_link")
    assert page_source =~ "#{user.first_name} #{user.last_name}"
  end
end
