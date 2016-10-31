defmodule PhoenixSocial.Post do
  use PhoenixSocial.Web, :model

  schema "posts" do
    field :text, :string
    belongs_to :author, PhoenixSocial.Profile
    belongs_to :profile, PhoenixSocial.Profile
    has_many :comments, PhoenixSocial.Comment
    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
