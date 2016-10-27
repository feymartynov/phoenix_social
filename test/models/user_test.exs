defmodule PhoenixSocial.UserTest do
  use PhoenixSocial.ModelCase, async: true

  alias PhoenixSocial.User

  test "Full name: both first & last name" do
    user = %User{first_name: "John", last_name: "Doe"}
    assert User.full_name(user) == "John Doe"
  end

  test "Full name: only first name" do
    user = %User{first_name: "John"}
    assert User.full_name(user) == "John"
  end

  test "Full name: only last name" do
    user = %User{last_name: "Doe"}
    assert User.full_name(user) == "Doe"
  end

  test "Birthday validation: happy bath" do
    changeset = User.profile_changeset(%User{}, %{"birthday" => "1987-07-12"})
    assert changeset.valid?
    errors = User.error_messages(changeset)
    assert errors[:birthday] |> is_nil
  end

  test "Birthday validation: wrong format" do
    changeset = User.profile_changeset(%User{}, %{"birthday" => "12345abcd"})
    refute changeset.valid?
    errors = User.error_messages(changeset)
    assert errors[:birthday] |> List.first == "is invalid"
  end

  test "Birthday validation: too old" do
    changeset = User.profile_changeset(%User{}, %{"birthday" => "1634-01-14"})
    refute changeset.valid?
    errors = User.error_messages(changeset)
    assert errors[:birthday] |> List.first == "too long ago"
  end

  test "Birthday validation: in future" do
    changeset = User.profile_changeset(%User{}, %{"birthday" => "2994-11-08"})
    refute changeset.valid?
    errors = User.error_messages(changeset)
    assert errors[:birthday] |> List.first == "is in future"
  end
end
