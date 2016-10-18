defmodule PhoenixSocial.User do
  use PhoenixSocial.Web, :model
  use Arc.Ecto.Schema

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :avatar, PhoenixSocial.Avatar.Type
    field :birthday, Ecto.Date
    field :gender, :string
    field :marital_status, :string
    field :city, :string
    field :languages, :string
    field :occupation, :string
    field :interests, :string
    field :favourite_music, :string
    field :favourite_movies, :string
    field :favourite_books, :string
    field :favourite_games, :string
    field :favourite_cites, :string
    field :about, :string
    timestamps
    has_many :friendships, PhoenixSocial.Friendship, foreign_key: :user1_id
    has_many :friends, through: [:friendships, :user2]
  end

  def full_name(user) do
    [user.first_name, user.last_name]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
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

  @profile_fields [
    :birthday, :gender, :marital_status, :city, :languages, :occupation,
    :interests, :favourite_music, :favourite_movies, :favourite_books,
    :favourite_games, :favourite_cites, :about]

  @marital_statuses [
    "single", "in a relationship", "engaged", "married", "in love",
    "complicated", "actively searching"]

  def profile_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @profile_fields)
    |> validate_birthday
    |> validate_inclusion(:gender, ["male", "female"])
    |> validate_inclusion(:marital_status, @marital_statuses)
  end

  def update_avatar(user, path) do
    avatar =
      if path do
        %{filename: "user#{user.id}.jpg", path: path}
      else
        nil
      end

    cast_attachments(user, %{"avatar" => avatar}, [:avatar])
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

  defp validate_birthday(changeset) do
    value = changeset.changes[:birthday]

    cond do
      is_nil(value) ->
        changeset
      Ecto.Date.compare(value, Ecto.Date.cast!({1900, 1, 1})) == :lt ->
        changeset |> add_error(:birthday, "too long ago")
      Ecto.Date.compare(value, Ecto.Date.cast!(DateTime.utc_now)) == :gt ->
        changeset |> add_error(:birthday, "is in future")
      true ->
        changeset
    end
  end
end

defimpl String.Chars, for: PhoenixSocial.User do
  def to_string(user), do: PhoenixSocial.User.full_name(user)
end
