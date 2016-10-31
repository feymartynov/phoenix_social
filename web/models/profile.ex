defmodule PhoenixSocial.Profile do
  use PhoenixSocial.Web, :model
  use Arc.Ecto.Schema

  schema "profiles" do
    field :first_name, :string
    field :last_name, :string
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
    belongs_to :user, PhoenixSocial.User
  end

  def slug(profile) do
    "user#{profile.id}"
  end

  def full_name(profile) do
    [profile.first_name, profile.last_name]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  @initial_fields [:first_name, :last_name]

  @profile_fields [
    :birthday, :gender, :marital_status, :city, :languages, :occupation,
    :interests, :favourite_music, :favourite_movies, :favourite_books,
    :favourite_games, :favourite_cites, :about]

  @marital_statuses [
    "single", "in a relationship", "engaged", "married", "in love",
    "complicated", "actively searching"]

  def initial_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @initial_fields)
    |> validate_required(@initial_fields)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @profile_fields)
    |> validate_birthday
    |> validate_inclusion(:gender, ["male", "female"])
    |> validate_inclusion(:marital_status, @marital_statuses)
  end

  def update_avatar(profile, path) do
    avatar =
      if path do
        %{filename: "#{profile |> slug}.jpg", path: path}
      else
        nil
      end

    cast_attachments(profile, %{"avatar" => avatar}, [:avatar])
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

defimpl String.Chars, for: PhoenixSocial.Profile do
  def to_string(profile), do: PhoenixSocial.Profile.full_name(profile)
end
