defmodule PhoenixSocial.Factory do
  use ExMachina.Ecto, repo: PhoenixSocial.Repo

  def user_factory do
    %PhoenixSocial.User{
      first_name: "John",
      last_name: "Doe",
      email: sequence(:email, &"email-#{&1}@example.com"),
      encrypted_password: "$2b$12$r5FNliorADmHchCdwBVe2O70mbCeIMU2lR1gbRV/O1ztLf39C2Qka"} # 12345
  end

  def friendship_factory do
    %PhoenixSocial.Friendship{
      user1: build(:user),
      user2: build(:user),
      state: "confirmed"}
  end

  def post_factory do
    %PhoenixSocial.Post{
      user: build(:user),
      author: build(:user),
      text: sequence(:text, &"post ##{&1}")}
  end
end
