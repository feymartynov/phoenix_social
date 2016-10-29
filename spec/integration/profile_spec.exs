defmodule PhoenixSocial.Integration.ProfileSpec do
  use ESpec.Phoenix.Extend, :integration

  defp edit_profile_field(field, value) do
    # edit contenteditable element
    dd = find_element(:css, "dd[data-field='#{field}']")
    dd |> click
    dd |> fill_field(value)

    # click anywhere on the page to submit
    find_element(:css, "body") |> click
  end

  let! :current_user, do: insert(:user) |> sign_in

  context "with own profile" do
    before do
      navigate_to "/user#{current_user.id}"
    end

    it "changes a profile field" do
      edit_profile_field("occupation", "dvlpr")

      assert visible_page_text =~ "dvlpr"
      refresh_page
      assert visible_page_text =~ "dvlpr"
    end

    it "fails with invalid value" do
      edit_profile_field("birthday", "qweqwe")

      alert = find_element(:css, ".alert")
      assert alert |> inner_text =~ "Birthday is invalid"
    end
  end

  context "with someone else's profile" do
    let! :user, do: insert(:user, city: "Moscow", occupation: "dvlpr")

    it "shows user's profile fields" do
      navigate_to "/user#{user.id}"

      assert visible_page_text =~ "City\nMoscow"
      assert visible_page_text =~ "Occupation\ndvlpr"
    end
  end
end
