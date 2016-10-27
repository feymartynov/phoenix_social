defmodule PhoenixSocial.AvatarControllerTest do
  use PhoenixSocial.ConnCase

  test "Upload avatar" do
    user = insert(:user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

    body = %{
      avatar: %Plug.Upload{
        filename: "avatar.jpg",
        path: "test/files/avatar.jpg"}}

    on_exit fn ->
      File.rm_rf!("uploads/avatars/user#{user.id}")
    end

    response =
      build_conn
      |> put_req_header("authorization", jwt)
      |> post("/api/v1/avatar", body)

    assert response.status == 201

    json = Poison.decode!(response.resp_body)
    expected_path = "/uploads/avatars/user#{user.id}/user#{user.id}_big.jpg"
    assert json["user"]["avatar"]["big"] == expected_path
  end

  test "Remove avatar" do
    user = insert(:user, avatar: %{file_name: "avatar.jpg", updated_at: nil})
    avatar_path = "priv/static/uploads/avatars/user#{user.id}/user#{user.id}_big.jpg"
    Path.dirname(avatar_path) |> File.mkdir_p!
    File.cp!("test/files/avatar.jpg", avatar_path)

    on_exit fn ->
      Path.dirname(avatar_path) |> File.rm_rf!
    end

    assert {200, json} = api_call(:delete, "/avatar", as: user)
    assert json["user"]["avatar"] == nil

    refute File.exists?(avatar_path)
    user = Repo.get(PhoenixSocial.User, user.id)
    assert is_nil(user.avatar)
  end
end
