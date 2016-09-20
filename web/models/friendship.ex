defmodule PhoenixSocial.Friendship do
  use PhoenixSocial.Web, :model

  alias PhoenixSocial.Repo

  @primary_key false
  schema "friendships" do
    field :state, :string
    belongs_to :user1, PhoenixSocial.User, primary_key: true
    belongs_to :user2, PhoenixSocial.User, primary_key: true
    timestamps
  end

  def back_friendship(friendship) do
    Repo.one(
      from f in __MODULE__,
      where: f.user1_id == ^friendship.user2_id and
             f.user2_id == ^friendship.user1_id)
  end

  def toggle_state(friendship, state) do
    friendship
    |> __MODULE__.changeset(%{state: state})
    |> Repo.update
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state])
    |> validate_required([:state])
    |> unique_constraint(:user2, name: :friendships_user1_id_user2_id_index)
  end
end

defimpl Poison.Encoder, for: PhoenixSocial.Friendship do
  def encode(friendship, _options) do
    friendship.user2
    |> Map.take([:id, :first_name, :last_name])
    |> Map.put(:friendship_state, friendship.state)
    |> Poison.encode!
  end
end
