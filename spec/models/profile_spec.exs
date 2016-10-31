defmodule PhoenixSocial.ProfileSpec do
  use ESpec.Phoenix, model: Profile, async: true

  alias PhoenixSocial.Profile

  describe "#full_name" do
    it "shows both first & last name" do
      profile =%Profile{first_name: "John", last_name: "Doe"}
      assert Profile.full_name(profile) == "John Doe"
    end

    it "shows only the first name" do
      profile =%Profile{first_name: "John"}
      assert Profile.full_name(profile) == "John"
    end

    it "shows only the last name" do
      profile =%Profile{last_name: "Doe"}
      assert Profile.full_name(profile) == "Doe"
    end
  end

  describe "#changeset" do
    context "birthday validation" do
      it "should accept valid date" do
        changeset = Profile.changeset(%Profile{}, %{"birthday" => "1987-07-12"})
        assert changeset.valid?
        errors = Profile.error_messages(changeset)
        refute errors[:birthday]
      end

      it "should reject wrong format" do
        changeset = Profile.changeset(%Profile{}, %{"birthday" => "12345abcd"})
        refute changeset.valid?
        errors = Profile.error_messages(changeset)
        assert errors[:birthday] |> List.first == "is invalid"
      end

      it "should reject too longtime date" do
        changeset = Profile.changeset(%Profile{}, %{"birthday" => "1634-01-14"})
        refute changeset.valid?
        errors = Profile.error_messages(changeset)
        assert errors[:birthday] |> List.first == "too long ago"
      end

      it "should reject future date" do
        changeset = Profile.changeset(%Profile{}, %{"birthday" => "2994-11-08"})
        refute changeset.valid?
        errors = Profile.error_messages(changeset)
        assert errors[:birthday] |> List.first == "is in future"
      end
    end
  end
end
