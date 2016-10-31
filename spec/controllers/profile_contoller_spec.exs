defmodule PhoenixSocial.ProfileControllerSpec do
  use ESpec.Phoenix, controller: ProfileController

  let :user, do: insert(:user)

  describe "#show" do
    it "shows the profile" do
      profile =
        insert(:profile, user: user, first_name: "John", last_name: "Lennon")

      url = "/profiles/#{profile.id}"
      assert {200, json} = api_call(:get, url, as: insert(:user))
      assert json["profile"]["id"] == profile.id
      assert json["profile"]["first_name"] == "John"
      assert json["profile"]["last_name"] == "Lennon"
    end
  end

  describe "#update" do
    it "updates the profile" do
      profile = insert(:profile, user: user, city: "St. Petersburg")

      url = "/profiles/#{profile.id}"
      body = %{"profile" => %{"city" => "Moscow"}}
      assert {200, json} = api_call(:put, url, body: body, as: user)
      assert json["profile"]["id"] == profile.id
      assert json["profile"]["city"] == "Moscow"
    end

    it "fails to update the profile with wrong params" do
      profile = insert(:profile, user: user)

      body = %{"profile" => %{"birthday" => "0000-12-34"}}
      url = "/profiles/#{profile.id}"
      assert {422, json} = api_call(:put, url, body: body, as: user)
      assert json["error"]["birthday"] |> List.first == "is invalid"
    end

    it "forbids updating another user's profile" do
      profile = insert(:profile, user: user)

      url = "/profiles/#{profile.id}"
      body = %{"profile" => %{"city" => "Moscow"}}
      assert {403, json} = api_call(:put, url, body: body, as: insert(:user))
      assert json["error"] == "Forbidden"
    end
  end
end
