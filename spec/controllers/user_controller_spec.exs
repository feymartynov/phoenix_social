defmodule PhoenixSocial.UserControllerSpec do
  use ESpec.Phoenix, controller: UserController

  describe "#create" do
    it "signs up a user" do
      body = %{
        "user" => %{
          "email" => "johndoe@example.com",
          "first_name" => "John",
          "last_name" => "Doe",
          "password" => "12345",
          "password_confirmation" => "12345" }}

      assert {201, json} = api_call(:post, "/users", body: body)
      assert json["user"]["id"] |> is_integer
      assert json["user"]["first_name"] == "John"
      assert json["user"]["last_name"] == "Doe"
      assert json["jwt"] |> is_binary
    end

    it "fails to sign up registration with wrong params" do
      body = %{
        "user" => %{
          "first_name" => "John",
          "last_name" => "Doe",
          "password" => "12345",
          "password_confirmation" => "12345678" }}

      assert {422, json} = api_call(:post, "/users", body: body)
      assert json["error"]["email"] |> List.first == "can't be blank"

      confirmation_error = json["error"]["password_confirmation"] |> List.first
      assert confirmation_error == "does not match confirmation"
    end
  end

  describe "#update" do
    it "updates the profile" do
      user = insert(:user, city: "St. Petersburg")

      body = %{"user" => %{"city" => "Moscow"}}
      assert {200, json} = api_call(:put, "/users/current", body: body, as: user)
      assert json["user"]["id"] == user.id
      assert json["user"]["city"] == "Moscow"
    end

    it "fails to update the profile with wrong params" do
      user = insert(:user)

      body = %{"user" => %{"birthday" => "0000-12-34"}}
      assert {422, json} = api_call(:put, "/users/current", body: body, as: user)
      assert json["error"]["birthday"] |> List.first == "is invalid"
    end

    it "forbids updating another user's profile" do
      {user, other_user} = {insert(:user), insert(:user)}

      url = "/users/#{user.id}"
      body = %{"user" => %{"city" => "Moscow"}}
      assert {403, json} = api_call(:put, url, body: body, as: other_user)
      assert json["error"] == "Forbidden"
    end
  end

  describe "#show" do
    let :user, do: insert(:user)

    it "fails to show not found user" do
      assert {404, json} = api_call(:get, "/users/0123", as: user)
      assert json["error"] == "User not found"
    end

    context "with friends" do
      let :friend1, do: insert(:user)
      let :friend2, do: insert(:user)

      before do
        insert(:friendship, user1: user, user2: friend1, state: "confirmed")
        insert(:friendship, user1: friend1, user2: user, state: "confirmed")

        insert(:friendship, user1: user, user2: friend2, state: "pending")
        insert(:friendship, user1: friend2, user2: user, state: "confirmed")
      end

      it "shows all friends for current user" do
        assert {200, json} = api_call(:get, "/users/current", as: user)
        assert length(json["user"]["friendships"]) == 2
        states = Enum.map(json["user"]["friendships"], &(&1["state"]))
        assert Enum.sort(states) == ["confirmed", "pending"]
      end

      it "shows only confirmed friends for another user" do
        assert {200, json} = api_call(:get, "/users/#{user.id}", as: insert(:user))
        assert length(json["user"]["friendships"]) == 1
        assert List.first(json["user"]["friendships"])["state"] == "confirmed"
      end
    end
  end
end
