defmodule PhoenixSocial.Friendship do
  use PhoenixSocial.Web, :model

  @primary_key false
  schema "friendships" do
    field :state, :string
    belongs_to :user1, PhoenixSocial.User, primary_key: true
    belongs_to :user2, PhoenixSocial.User, primary_key: true
    timestamps
  end

  def back_friendship(friendship) do
    from f in __MODULE__,
    where: f.user1_id == ^friendship.user2_id and
           f.user2_id == ^friendship.user1_id
  end

  def toggle_state(friendship, state) do
    __MODULE__.changeset(friendship, %{state: state})
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state])
    |> validate_required([:state])
    |> unique_constraint(:user2, name: :friendships_user1_id_user2_id_index)
  end
end
