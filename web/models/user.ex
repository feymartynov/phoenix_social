defmodule PhoenixSocial.User do
  use PhoenixSocial.Web, :model

  alias PhoenixSocial.Profile

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    timestamps
    has_one :profile, Profile
    has_many :friendships, PhoenixSocial.Friendship, foreign_key: :user1_id
    has_many :friends, through: [:friendships, :user2]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> cast_assoc(:profile, required: true, with: &Profile.initial_changeset/2)
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password)
    |> unique_constraint(:email, name: :users_lower_email_index)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        encrypted_password = Comeonin.Bcrypt.hashpwsalt(password)
        put_change(changeset, :encrypted_password, encrypted_password)
      _ ->
        changeset
    end
  end
end
