defmodule PhoenixSocial.Integration.AuthenticationSpec do
  use ESpec.Phoenix.Extend, :integration

  context "with session cleanup" do
    before do
      navigate_to "/"

      execute_script """
        localStorage.removeItem('phoenixSocialAuthToken');
      """
    end

    it "signs in" do
      navigate_to "/sign_in"

      user =
        insert(
          :user,
          profile: build(:profile, first_name: "John", last_name: "Lennon"))

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

      user_menu = find_element(:id, "user_menu")
      assert user_menu |> inner_text =~ "John Lennon"
    end

    it "signs up" do
      navigate_to "/sign_up"

      sign_in_form = find_element(:id, "sign_up_form")

      sign_in_form
      |> find_within_element(:name, "first_name")
      |> fill_field("John")

      sign_in_form
      |> find_within_element(:name, "last_name")
      |> fill_field("Lennon")

      sign_in_form
      |> find_within_element(:name, "email")
      |> fill_field("john@beatles.com")

      sign_in_form
      |> find_within_element(:name, "password")
      |> fill_field("12345")

      sign_in_form
      |> find_within_element(:name, "password_confirmation")
      |> fill_field("12345")

      sign_in_form
      |> find_within_element(:id, "sign_up_button")
      |> click

      user_menu = find_element(:id, "user_menu")
      assert user_menu |> inner_text =~ "John Lennon"
    end
  end

  it "signs out" do
    insert(:user) |> sign_in

    navigate_to "/"
    find_element(:id, "user_menu") |> click
    find_element(:id, "sign_out_link") |> click

    assert find_element(:id, "sign_in_button")
  end
end
