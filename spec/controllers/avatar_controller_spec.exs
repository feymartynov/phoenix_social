defmodule PhoenixSocial.AvatarControllerSpec do
  use ESpec.Phoenix, controller: AvatarController

  describe "#create" do
    let :user, do: insert(:user)

    let :jwt do
      {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
      jwt
    end

    finally do
      File.rm_rf!("uploads/avatars/user#{user.id}")
    end

    it "uploads avatar" do
      body = %{
        avatar: %Plug.Upload{
          filename: "avatar.jpg",
          path: "spec/files/avatar.jpg"}}

      response =
        build_conn
        |> put_req_header("authorization", jwt)
        |> post("/api/v1/avatar", body)

      assert response.status == 201

      json = Poison.decode!(response.resp_body)
      expected_path = "/uploads/avatars/user#{user.id}/user#{user.id}_big.jpg"
      assert json["user"]["avatar"]["big"] == expected_path
    end
  end

  describe "#delete" do
    let :user do
      insert(:user, avatar: %{file_name: "avatar.jpg", updated_at: nil})
    end

    let :avatar_path do
      "priv/static/uploads/avatars/user#{user.id}/user#{user.id}_big.jpg"
    end

    finally do
      Path.dirname(avatar_path) |> File.rm_rf!
    end

    it "removes avatar" do
      Path.dirname(avatar_path) |> File.mkdir_p!
      File.cp!("spec/files/avatar.jpg", avatar_path)

      assert {200, json} = api_call(:delete, "/avatar", as: user)
      assert json["user"]["avatar"] == nil

      refute File.exists?(avatar_path)
      refute Repo.get!(PhoenixSocial.User, user.id).avatar
    end
  end
end
