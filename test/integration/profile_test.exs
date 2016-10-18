defmodule PhoenixSocial.Integration.ProfileTest do
  use PhoenixSocial.IntegrationCase

  @tag :integration
  test "See users' profile fields" do
    insert(:user) |> sign_in

    user = insert(:user, city: "Moscow", occupation: "dvlpr")
    navigate_to "/user#{user.id}"

    assert visible_page_text =~ "City\nMoscow"
    assert visible_page_text =~ "Occupation\ndvlpr"
  end

  @tag :integration
  test "Change a profile field" do
    user = insert(:user) |> sign_in
    navigate_to "/user#{user.id}"

    # edit contenteditable element
    dd = find_element(:css, "dd[data-field='occupation']")
    dd |> click
    dd |> fill_field("dvlpr")

    # click anywhere on the page to submit
    find_element(:css, "body") |> click
    assert visible_page_text =~ "dvlpr"

    # changes should persist after refresh
    refresh_page
    assert visible_page_text =~ "dvlpr"
  end

  @tag :integration
  test "Try to put an invalid value" do
    user = insert(:user) |> sign_in
    navigate_to "/user#{user.id}"

    # edit contenteditable element
    dd = find_element(:css, "dd[data-field='birthday']")
    dd |> click
    dd |> fill_field("qweqwe")

    # click anywhere on the page to submit
    find_element(:css, "body") |> click

    # should see an error in the alert box
    alert = find_element(:css, ".alert")
    assert alert |> inner_text =~ "Birthday is invalid"
  end
end
