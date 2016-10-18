defmodule PhoenixSocial.AvatarTest do
  use PhoenixSocial.ModelCase, async: true

  alias PhoenixSocial.Avatar

  setup do
    %{user: build(:user, id: 123)}
  end

  test "URLs", %{user: user} do
    urls = Avatar.public_urls({%{file_name: "user123.jpg?101010"}, user})
    assert urls == %{big: "/uploads/avatars/user123/user123_big.jpg?101010"}
  end

  test "Storage directory", %{user: user} do
    dir = Avatar.storage_dir(:big, {%{file_name: "user123.jpg?101010"}, user})
    assert dir == "priv/static/uploads/avatars/user123"
  end

  test "Filename", %{user: user} do
    filename = Avatar.filename(:big, {%{file_name: "user123.jpg?101010"}, user})
    assert filename == "user123_big"
  end
end