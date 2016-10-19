defmodule PhoenixSocial.Post do
  use PhoenixSocial.Web, :model

  schema "posts" do
    field :text, :string
    belongs_to :author, PhoenixSocial.User
    belongs_to :user, PhoenixSocial.User
    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
