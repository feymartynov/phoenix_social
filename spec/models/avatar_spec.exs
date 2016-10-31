defmodule PhoenixSocial.AvatarSpec do
  use ESpec.Phoenix, model: Avatar, async: true

  alias PhoenixSocial.Avatar

  let :profile, do: build(:profile, id: 123)

  describe "#public_urls" do
    it "should return urls for all versions" do
      urls = Avatar.public_urls({%{file_name: "profile123.jpg?101010"}, profile})

      expected_urls = %{
        big: "/uploads/avatars/profile123/profile123_big.jpg?101010",
        medium: "/uploads/avatars/profile123/profile123_medium.jpg?101010",
        thumb: "/uploads/avatars/profile123/profile123_thumb.jpg?101010"}

      assert urls == expected_urls
    end
  end

  describe "#storage_dir" do
    it "should return directory path to store the avatar into" do
      dir =
        Avatar.storage_dir(:big, {%{file_name: "profile123.jpg?101010"}, profile})

      assert dir == "priv/static/uploads/avatars/profile123"
    end
  end

  describe "#filename" do
    it "it should return the filename for a version" do
      filename =
        Avatar.filename(:big, {%{file_name: "profile123.jpg?101010"}, profile})

      assert filename == "profile123_big"
    end
  end
end
