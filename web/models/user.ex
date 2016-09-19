defmodule PhoenixSocial.User do
  use PhoenixSocial.Web, :model

  @derive {Poison.Encoder, only: [:id, :first_name, :last_name, :email]}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    timestamps
    has_many :friendships, PhoenixSocial.Friendship, foreign_key: :user1_id
    has_many :friends, through: [:friendships, :user2]
  end

  def full_name(user) do
    [user.first_name, user.last_name] |> Enum.join(" ")
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :password])
    |> validate_required([:first_name, :last_name, :email, :password])
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
