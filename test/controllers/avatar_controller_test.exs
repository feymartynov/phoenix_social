defmodule PhoenixSocial.AvatarControllerTest do
  use PhoenixSocial.ConnCase

  test "Upload avatar" do
    user = insert(:user)

    body = %{
      avatar: %Plug.Upload{
        filename: "avatar.jpg",
        path: "test/files/avatar.jpg"}}

    on_exit fn ->
      File.rm_rf!("uploads/avatars/user#{user.id}")
    end

    {201, json} = api_call(:post, "/avatar", body: body, as: user)
    assert json["big"] =~ "uploads/avatars/user#{user.id}/user#{user.id}_big.jpg"
  end

  test "Remove avatar" do
    user = insert(:user, avatar: %{file_name: "avatar.jpg", updated_at: nil})
    avatar_path = "priv/static/uploads/avatars/user#{user.id}/user#{user.id}_big.jpg"
    Path.dirname(avatar_path) |> File.mkdir_p!
    File.cp!("test/files/avatar.jpg", avatar_path)

    on_exit fn ->
      Path.dirname(avatar_path) |> File.rm_rf!
    end

    assert {204, _} = api_call(:delete, "/avatar", as: user)
    assert !File.exists?(avatar_path)
    user = Repo.get(PhoenixSocial.User, user.id)
    assert is_nil(user.avatar)
  end
end
