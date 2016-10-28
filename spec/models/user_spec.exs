defmodule PhoenixSocial.UserSpec do
  use ESpec.Phoenix, model: User, async: true

  alias PhoenixSocial.User

  describe "#full_name" do
    it "shows both first & last name" do
      user = %User{first_name: "John", last_name: "Doe"}
      assert User.full_name(user) == "John Doe"
    end

    it "shows only the first name" do
      user = %User{first_name: "John"}
      assert User.full_name(user) == "John"
    end

    it "shows only the last name" do
      user = %User{last_name: "Doe"}
      assert User.full_name(user) == "Doe"
    end
  end

  describe "#profile_changeset" do
    context "birthday validation" do
      it "should accept valid date" do
        changeset = User.profile_changeset(%User{}, %{"birthday" => "1987-07-12"})
        assert changeset.valid?
        errors = User.error_messages(changeset)
        assert errors[:birthday] |> is_nil
      end

      it "should reject wrong format" do
        changeset = User.profile_changeset(%User{}, %{"birthday" => "12345abcd"})
        refute changeset.valid?
        errors = User.error_messages(changeset)
        assert errors[:birthday] |> List.first == "is invalid"
      end

      it "should reject too longtime date" do
        changeset = User.profile_changeset(%User{}, %{"birthday" => "1634-01-14"})
        refute changeset.valid?
        errors = User.error_messages(changeset)
        assert errors[:birthday] |> List.first == "too long ago"
      end

      it "should reject future date" do
        changeset = User.profile_changeset(%User{}, %{"birthday" => "2994-11-08"})
        refute changeset.valid?
        errors = User.error_messages(changeset)
        assert errors[:birthday] |> List.first == "is in future"
      end
    end
  end
end
